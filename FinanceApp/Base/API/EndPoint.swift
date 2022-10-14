//
//  EndPoint.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/8/22.
//

import Foundation

enum EndPoint {
    case market(region: String)
    case stock(symbol: String)
}

extension EndPoint {
    enum MethodType: Equatable {
        case GET
    }
}

extension EndPoint {
    var host: String { "yh-finance.p.rapidapi.com" }
    var path: String {
        switch self {
        case .market:
            return "/market/v2/get-summary"
        case .stock:
            return "/stock/v2/get-summary"
        }
    }
    
    var methodType: MethodType {
        return .GET
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .market(let region):
            return ["region":"\(region)"]
        case .stock(let symbol):
            return ["symbol":"\(symbol)"]
        }
    }    
}

extension EndPoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
