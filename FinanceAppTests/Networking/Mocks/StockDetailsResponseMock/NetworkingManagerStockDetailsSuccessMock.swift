//
//  NetworkingManagerStockDetailsSuccessMock.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/14/22.
//

import Foundation
@testable import FinanceApp

class NetworkingManagerStockDetailsSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "stockDetails", type: StockDetailsModel.self) as! T
    }
    
}
