//
//  JsonMapperTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/13/22.
//

import Foundation
import XCTest
@testable import FinanceApp

class JsonMapperTests: XCTestCase {
    
    func test_with_valid_json_successfully_decoded() {
        XCTAssertNoThrow(try StaticJSONMapper.decode(file: "marketList", type: MarketListModel.self), "Mapper shouldn't throw an error")

        let marketListModel = try? StaticJSONMapper.decode(file: "marketList", type: MarketListModel.self)
        XCTAssertNotNil(marketListModel, "marketListModel response shouldn't be nil")

        XCTAssertEqual(marketListModel?.marketSummaryAndSparkResponse.result.count, 16, "Market result count should be 16")
    }
    
    func test_with_missing_file_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "", type: MarketListModel.self), "An error should be thrown")
        do {
            _ = try StaticJSONMapper.decode(file: "", type: MarketListModel.self)
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of mapping error for missing files")
                return
            }
            XCTAssertEqual(mappingError, StaticJSONMapper.MappingError.failedToMapContents, "This should be a failed to get contents error")
        }
    }
    
    
    func test_with_invalid_file_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "xxxxx", type: MarketListModel.self), "An error should be thrown")
        do {
            _ = try StaticJSONMapper.decode(file: "xxxxx", type: MarketListModel.self)
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of mapping error for missing files")
                return
            }
            XCTAssertEqual(mappingError, StaticJSONMapper.MappingError.failedToMapContents, "This should be a failed to get contents error")
        }
    }

    
    func test_with_invalid_json_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "stockDetails", type: MarketListModel.self), "An error should be thrown")
        do {
            _ = try StaticJSONMapper.decode(file: "stockDetails", type: MarketListModel.self)
        } catch {
            if error is StaticJSONMapper.MappingError {
                XCTFail("Got the wrong type of error, expecting a system decoding error.")
            }
        }
    }
}
