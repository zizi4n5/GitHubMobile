//
//  GitHubClient.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/27.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import Apollo
import Extentions
import OAuthSwift

public typealias GitHubUser = LoginUserQuery.Data.Viewer
public typealias GitHubPageInfo = SearchRepositoriesQuery.Data.Search.PageInfo
public typealias GitHubRepository = SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository

fileprivate let oauthswift = OAuth2Swift(
    consumerKey:    "4dd6e2ec2e03119aa7bd",
    consumerSecret: "6e1847dac03635fa3d0e9de2c28c86f57f4d38b0",
    authorizeUrl:   "https://github.com/login/oauth/authorize",
    accessTokenUrl: "https://github.com/login/oauth/access_token",
    responseType:   "token"
)

fileprivate let callbackUrl = URL(string: "zizi4n5githubmobile://oauth-callback")!

public class GitHubClient {
    
    static public func login(resultHandler: @escaping ((String?, Error?) -> Swift.Void)) {
        
        let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: callbackUrl, scope: "repo", state: state,
            success: { credential, response, parameters in
                resultHandler(credential.oauthToken, nil)
            },
                failure: { error in
                    resultHandler(nil, error)
            }
        )
    }
    
    private let apollo: ApolloClient
    public let token: String
    public var isLoading = false
    
    public init(token: String) {
        self.token = token
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData // To avoid 412
        
        let url = URL(string: "https://api.github.com/graphql")!
        apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }

    public func getLoginUser(resultHandler: @escaping ((GitHubUser?, Error?) -> Swift.Void)) {
        apollo.fetch(query: LoginUserQuery(), cachePolicy: .fetchIgnoringCacheData) { (result, error) in
            
            if let error = error {
                print("Error: \(error)");
                return resultHandler(nil, error)
            }
            
            guard let viewer = result?.data?.viewer else {
                return resultHandler(nil, error)
            }
            
            return resultHandler(viewer, nil)
        }
    }
    
    public func getRepositories(first: Int, after: GitHubPageInfo? = nil, resultHandler: @escaping ((GitHubPageInfo?, [GitHubRepository?], Error?) -> Swift.Void)) {
        isLoading = true
        let queryString = "language:Swift sort:stars-desc" // 昇順
        
//        apollo.fetch(query: SearchRepositoriesQuery(queryString: queryString, first: first, after: after)) { (result, error) in
        apollo.fetch(query: SearchRepositoriesQuery(queryString: queryString, first: first, after: after?.endCursor), cachePolicy: .fetchIgnoringCacheData) { (result, error) in
            
            defer {
                self.isLoading = false
            }
        
            if let error = error {
                print("Error: \(error)");
            }

            let pageInfo = self.getPageInfo(from: result)
            let repositories = self.getRepositories(from: result)
            return resultHandler(pageInfo, repositories, nil)
        }
    }
    
    private func getPageInfo(from result: GraphQLResult<SearchRepositoriesQuery.Data>?) -> SearchRepositoriesQuery.Data.Search.PageInfo? {
        
        guard let pageInfo = result?.data?.search.pageInfo else {
            return nil
        }
        
        return pageInfo
    }
    
    
    private func getRepositories(from result: GraphQLResult<SearchRepositoriesQuery.Data>?) -> [GitHubRepository] {
        
        var repositories = [GitHubRepository]()
        
        guard let edges = result?.data?.search.edges else {
            return repositories
        }
        
        for edge in edges {
            
            guard let repository = edge?.node?.asRepository else {
                continue
            }
            
            repositories.append(repository)
        }
        
        return repositories
    }
}
