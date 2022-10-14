//
//  NetworkingEndpointTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/13/22.
//

import XCTest
@testable import FinanceApp

class NetworkingEndpointTests: XCTestCase {

    func test_with_market_endpoint_request_is_valid() {
        let endpoint = EndPoint.market(region: "US")
        XCTAssertEqual(endpoint.host, "yh-finance.p.rapidapi.com", "The host should be yh-finance.p.rapidapi.com")
        XCTAssertEqual(endpoint.path, "/market/v2/get-summary", "The path should be /market/v2/get-summary")
        XCTAssertEqual(endpoint.methodType, .GET, "The method type should be GET")
        XCTAssertEqual(endpoint.queryItems, ["region":"US"], "The query items should be region:US")
        
        XCTAssertEqual(endpoint.url, URL(string: "https://yh-finance.p.rapidapi.com/market/v2/get-summary?region=US"), "The generated doesn't match our endpoint")
    }

    func test_with_stock_endpoint_request_is_valid() {
        let symbol = "BTC-USD"
        let endpoint = EndPoint.stock(symbol: symbol)
        XCTAssertEqual(endpoint.host, "yh-finance.p.rapidapi.com", "The host should be yh-finance.p.rapidapi.com")
        XCTAssertEqual(endpoint.path, "/stock/v2/get-summary", "The path should be /stock/v2/get-summary")
        XCTAssertEqual(endpoint.methodType, .GET, "The method type should be GET")
        XCTAssertEqual(endpoint.queryItems, ["symbol": symbol], "The query items should be symbol:YM=F")

        XCTAssertEqual(endpoint.url?.absoluteString, "https://yh-finance.p.rapidapi.com/stock/v2/get-summary?symbol=\(symbol)", "The generated doesn't match our endpoint")
    }

}
