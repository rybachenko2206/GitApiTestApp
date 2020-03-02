//
//  RepositoryItem.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


struct RepositoryItem: Decodable {
    let id: Int
    let fullName: String?
    let isPrivate: Bool
    let description: String?
    let url: URL?
    let updatedAt: Date?
    let pushedAt: Date?
    let owner: User
    
    enum CodingKeys: String, CodingKey {
        case id, description, owner, url
        case fullName = "full_name"
        case isPrivate = "private"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.owner = try container.decode(User.self, forKey: .owner)
        self.fullName = try? container.decode(String.self, forKey: .fullName)
        self.description = try? container.decode(String.self, forKey: .description)
        let isPrivate = try? container.decode(Bool.self, forKey: .isPrivate)
        self.isPrivate = isPrivate ?? false
        
        if let urlString = try? container.decode(String.self, forKey: .url) {
            self.url = URL(string: urlString)
        } else {
            self.url = nil
        }
        
        if let updatedAtStr = try? container.decode(String.self, forKey: .updatedAt) {
            self.updatedAt = CustomDateForrmatter.shared.date(fromIsoDateString: updatedAtStr)
        } else {
            self.updatedAt = nil
        }
        
        if let pushDateStr = try? container.decode(String.self, forKey: .pushedAt) {
            self.pushedAt = CustomDateForrmatter.shared.date(fromIsoDateString: pushDateStr)
        } else {
            self.pushedAt = nil
        }
    }
    
}


struct User: Decodable {
    let id: Int
    let login: String?
    let avatarUrl: URL?
    
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try? container.decode(String.self, forKey: .login)
        
        if let urlString = try? container.decode(String.self, forKey: .avatarUrl) {
            self.avatarUrl = URL(string: urlString)
        } else {
            self.avatarUrl = nil
        }
        
    }
}
