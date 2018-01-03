//
//  GitHubClient.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/27.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import Foundation
import Apollo
import UIKit
import Extentions
import OAuthSwift

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
            
            guard let name = result?.data?.viewer.name, let avatarUrl = result?.data?.viewer.avatarUrl else {
                return resultHandler(nil, error)
            }
            
            let user = GitHubUser(name: name, avatarUrl: URL(string: avatarUrl)!)
            return resultHandler(user, nil)
        }
    }
    
    public func getRepositories(first: Int, after: GitHubRepository? = nil, resultHandler: @escaping ((Int, [GitHubRepository], Error?) -> Swift.Void)) {
        isLoading = true
        let queryString = "language:Swift sort:stars-desc" // 昇順
        
//        apollo.fetch(query: SearchRepositoriesQuery(queryString: queryString, first: first, after: after)) { (result, error) in
        apollo.fetch(query: SearchRepositoriesQuery(queryString: queryString, first: first, after: after?.cursor), cachePolicy: .fetchIgnoringCacheData) { (result, error) in
            
            defer {
                self.isLoading = false
            }
        
            var repositories = [GitHubRepository]()
            
            if let error = error {
                print("Error: \(error)");
                return resultHandler(0, repositories, error)
            }
            
            guard let totalCount = result?.data?.search.repositoryCount, let edges = result?.data?.search.edges else {
                return resultHandler(0, repositories, nil)
            }

            for edge in edges {
                guard let edge = edge, let asRepository = edge.node?.asRepository else {
                    continue
                }
                
                let repository = GitHubRepository()
                repository.owner = (asRepository.owner.login, URL(string: asRepository.owner.avatarUrl)!, OwnerType(rawValue: asRepository.owner.__typename)!)
                repository.name = asRepository.name
                repository.nameWithOwner = asRepository.nameWithOwner
                repository.shortDescriptionHTML = asRepository.shortDescriptionHtml.convertHtml()
                repository.stargazersTotalCount = asRepository.stargazers.totalCount
                repository.url = URL(string: asRepository.url)
                repository.updatedAt = asRepository.updatedAt
                repository.cursor = edge.cursor

                if let primaryLanguage = asRepository.primaryLanguage {
                    repository.primaryLanguage = (primaryLanguage.name, UIColor(hexString: primaryLanguage.color))
                }
                
                asRepository.repositoryTopics.edges?.forEach { topicsEdge in
                    if let topic = topicsEdge?.node?.topic.name {
                        repository.topics.append(topic)
                    }
                }
                
                repositories.append(repository)
            }
            
            return resultHandler(totalCount, repositories, nil)
        }
    }
}
