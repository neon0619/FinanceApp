//
//  NetworkingManager.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/8/22.
//

import Foundation
import SwiftUI

protocol NetworkingManagerImpl {
    
    func request<T: Codable>(session: URLSession,
                             _ endpoint: EndPoint,
                             type: T.Type) async throws -> T
    
}

final class NetworkingManager: NetworkingManagerImpl {
    
    static let shared = NetworkingManager()
    private init() {}
    
    func request<T: Codable>(session: URLSession = .shared, _ endpoint: EndPoint, type: T.Type) async throws -> T {
        
        guard let url = endpoint.url else { throw NetworkingError.invalidURL }
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(T.self, from: data)
        
        return res
    }
    
}

extension NetworkingManager {
    enum NetworkingError: Error, LocalizedError {
        case invalidURL
        case custom(err: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "URL isn't valid"
            case .custom(err: let err):
                return "Something went wrong \(err.localizedDescription)"
            case .invalidStatusCode:
                return "Status code falls into the wrong range"
            case .invalidData:
                return "Response data is invalid"
            case .failedToDecode:
                return "Failed to decode"
            }
        }
    }
}

/* SPECIFICALLY CREATED A COMPARISON FOR EACH ENUM CASES CONFORMING TO EQUATABLE */
extension NetworkingManager.NetworkingError: Equatable {
    static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData):
            return true
        case (.failedToDecode(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}

private extension NetworkingManager {
    func buildRequest(from url: URL, methodType: EndPoint.MethodType) -> URLRequest {
        
        let apiKey = "272cc097bbmsh0b7fec011ca4beap1ded9djsn0bd8af7dc9be"
        let apiHost = "yh-finance.p.rapidapi.com"
        
        var request = URLRequest(url: url)
        let headers = ["X-RapidAPI-Key": apiKey, "X-RapidAPI-Host" : apiHost]
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        }
        return request
    }
     
}
