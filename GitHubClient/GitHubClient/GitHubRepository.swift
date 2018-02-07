//
//  GitHubRepository.swift
//  GitHubMobile
//
//  Created by zizi4n5 on 2017/12/29.
//  Copyright © 2017年 zizi4n5. All rights reserved.
//

import UIKit
import Apollo

public struct GitHubRepository: Codable {

    public struct Owner: Codable {
        
        public enum OwnerType: String, Codable {
            case User = "User"
            case Organization = "Organization"
        }
        
        public let login: String
        public let avatarUrl: URL
        public let __typename: OwnerType
    }

    public struct PrimaryLanguage: Codable {
        public let name: String
        public let color: UIColor?
        
        private enum CodingKeys: String, CodingKey {
            case name
            case color
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decode(String.self, forKey: .name)
            color = UIColor(hexString: try values.decode(String.self, forKey: .color))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(color?.toHexStringARGB(), forKey: .color)
        }
    }
    
    public struct Stargazers: Codable {
        public let totalCount: Int
    }
    
    public let name: String
    public let nameWithOwner: String
    public let owner: Owner
    public let shortDescriptionHTML: String
    public let topics: [String]?
    public let primaryLanguage: PrimaryLanguage
    public let stargazers: Stargazers
    public let url: URL
    public let updatedAt: String
}
