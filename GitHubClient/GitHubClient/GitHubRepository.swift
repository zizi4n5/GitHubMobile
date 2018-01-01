//
//  GitHubRepository.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import Foundation
import UIKit
import Apollo


public enum OwnerType: String {
    case User = "User"
    case Organization = "Organization"
}

public class GitHubRepository {
    
    public var name: String!
    public var nameWithOwner: String!
    public var owner: (name:String, avatarUrl: URL, type: OwnerType)!
    public var shortDescriptionHTML: NSAttributedString!
    public var topics = [String]()
    public var primaryLanguage: (name: String, color: UIColor?)!
    public var stargazersTotalCount: Int!
    public var url: URL!
    public var updatedAt: String!
    public var cursor: String!
    
    public init() {}
}
