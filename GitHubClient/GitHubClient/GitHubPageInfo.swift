//
//  GitHubPageInfo.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2018/02/07.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

public struct GitHubPageInfo: Codable {
    
    public let endCursor: String
    public let hasNextPage: Bool
    public let hasPreviousPage: Bool
    public let startCursor: String
}
