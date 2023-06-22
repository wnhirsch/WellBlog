//
//  Model.NewPost.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

extension Model {
    
    struct NewPost: Encodable {
        let title: String
        let description: String
    }
}
