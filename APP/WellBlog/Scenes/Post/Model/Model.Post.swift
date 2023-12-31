//
//  Model.Post.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Foundation

extension Model {
    
    struct Post: Decodable {
        let id: Int?
        let title: String?
        let description: String?
        let createdAt: Date?
        
        init(id: Int? = nil, title: String? = nil, description: String? = nil, createdAt: Date? = nil) {
            self.id = id
            self.title = title
            self.description = description
            self.createdAt = createdAt
        }
    }
}
