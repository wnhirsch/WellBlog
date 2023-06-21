//
//  MoyaResponse+Map.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Moya

extension Moya.Response {

    func mapObject<T: Decodable>(_ type: T.Type) throws -> T {
        let formatter = DateFormatter()
        formatter.timeZone = .gmt
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return try map(type, using: decoder)
    }
}
