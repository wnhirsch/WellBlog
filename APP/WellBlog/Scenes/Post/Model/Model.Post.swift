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
        
        init() {
            self.id = nil
            self.title = nil
            self.description = nil
            self.createdAt = nil
        }
    }
}
