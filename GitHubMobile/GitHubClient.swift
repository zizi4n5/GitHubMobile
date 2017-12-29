//
//  GitHubClient.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/27.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import Foundation
import Apollo
public class GitHubClient {
    
    let apollo: ApolloClient

    static let `default` = GitHubClient(token: "f8cf3573a35ce4807a525348215c72d3a29e3bbe")
    
    init(token: String) {
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData // To avoid 412
        
        let url = URL(string: "https://api.github.com/graphql")!
        apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }
    
    public func getRepositories(first: Int, after: String? = nil) {
        
        let queryString = "language:Swift sort:stars-desc" // 昇順
        apollo.fetch(query: SearchRepositoriesQuery(queryString: queryString, first: first, after: after)) { (result, error) in
            if let error = error {
                print("Error: \(error)");
                return
            }
            
            guard let search = result?.data?.search else {
                return
            }
            
            print("repositoryCount: \(search.repositoryCount)")

            search.edges?.forEach { edge in
                guard let repository = edge?.node?.asRepository else { return }
                print("cursor: \(edge!.cursor)")
                print("Name: \(repository.name)")
                print("Url: \(repository.url)")
                print("Stars: \(repository.stargazers.totalCount)")
            }
        }
    }
}
