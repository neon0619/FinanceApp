//
//  NetworkingManagerTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/13/22.
//

import XCTest
@testable import FinanceApp

class NetworkingManagerTests: XCTestCase {

    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {
        url = URL(string: "https://yh-finance.p.rapidapi.com/market/v2/get-summary")
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSesionProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func test_with_successful_response_that_response_is_valid() async throws {
        
        guard let path = Bundle.main.path(forResource: "marketList", ofType: ".json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static user file")
            return
        }
        
        MockURLSesionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        let res = try await NetworkingManager.shared.request(session: session,
                                                             .market(region: "US"),
                                                             type: MarketListModel.self)
        
        let staticJson = try StaticJSONMapper.decode(file: "marketList", type: MarketListModel.self)
        
        XCTAssertEqual(res, staticJson, "The returned response should be decoded properly")
    }
    
    func test_with_unsuccessful_response_code_in_invalide_range_is_invalid() async {
        
        let invalidStatusCode = 400
        
        MockURLSesionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: invalidStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, nil)
        }
        
        do {
            _ = try await NetworkingManager.shared.request(session: session,
                                                           .market(region: "US"),
                                                           type: MarketListModel.self)
        } catch {
            guard let networkingError = error as? NetworkingManager.NetworkingError else {
                XCTFail("Got the wrong type of error, Expecting NetworkingManager NetworkingError")
                return
            }
            
            XCTAssertEqual(networkingError,
                           NetworkingManager.NetworkingError.invalidStatusCode(statusCode: invalidStatusCode),
                           "Error should be networking error which throws an invalid status code.")
        }
    }
    
    
    func test_with_successful_response_with_invalid_json_is_invalid() async {
        
        guard let path = Bundle.main.path(forResource: "marketList", ofType: ".json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the static user file")
            return
        }
        
        MockURLSesionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (response!, data)
        }
        
        do {
            _ = try await NetworkingManager.shared.request(session: session,
                                                           .market(region: "US"),
                                                           type: MarketListModel.self)
        } catch {
            if error is NetworkingManager.NetworkingError {
                XCTFail("The error should be system decoding error.")
            }
        }
    }
}
