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
    
    var nameWithOwner: String!
    var owner: (name:String, avatarUrl: URL, type: OwnerType)!
    var shortDescriptionHTML: NSAttributedString!
    var topics = [String]()
    var primaryLanguage: (name: String, color: UIColor?)!
    var stargazersTotalCount: Int!
    var url: URL!
    var updatedAt: String!
    var cursor: String!
}
