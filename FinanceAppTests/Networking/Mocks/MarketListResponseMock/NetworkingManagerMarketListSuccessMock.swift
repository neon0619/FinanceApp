//
//  NetworkingManagerUserResponseSuccessMock.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/13/22.
//

import Foundation
@testable import FinanceApp

class NetworkingManagerMarketListSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, _ endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "marketList", type: MarketListModel.self) as! T
    }
    
}
