//
//  StaticJSONMapper.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/8/22.
//

import Foundation

struct StaticJSONMapper {
    
    enum MappingError: Error {
        case failedToMapContents
    }
    
    static func decode<T: Codable>(file: String, type: T.Type) throws -> T {
        
        guard !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: ".json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToMapContents
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
}
