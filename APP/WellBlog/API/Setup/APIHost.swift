//
//  APIHost.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Foundation

enum APIHost {
    
    static var baseURL: URL {
        URL(string: "https://wellblog.bsite.net/api/")!
        // You can change the Base URL adding localhost or other host here:
        // URL(string: "http://localhost:5232/api/")!
    }
    
    static var itemsPerPage: Int {
        10
    }
}
