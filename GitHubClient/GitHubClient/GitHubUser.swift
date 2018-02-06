//
//  GitHubUser.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

public class GitHubUser {
    
    public var name: String!
    public var avatarUrl: URL!
    
    public init(name: String, avatarUrl: URL) {
        self.name = name
        self.avatarUrl = avatarUrl
    }
}
