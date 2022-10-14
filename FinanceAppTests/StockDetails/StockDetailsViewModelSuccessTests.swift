//
//  StockDetailsViewModelSuccessTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/14/22.
//

import XCTest
@testable import FinanceApp

final class StockDetailsViewModelSuccessTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: StockDetailsViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerStockDetailsSuccessMock()
        vm = StockDetailsViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_successful_response_stock_details_is_set() async throws {
        
        XCTAssertFalse(vm.isLoading, "The view model should not be loading")
        
        defer {
            XCTAssertFalse(vm.isLoading, "The view model should not be loading")
        }
        
        await vm.fetchStockDetails(for: "BTC-USD")
        XCTAssertNotNil(vm.stockDetails, "The stock details in the view model should not be nil")
    
        let stockDetailsData = try StaticJSONMapper.decode(file: "stockDetails", type: StockDetailsModel.self)
        XCTAssertEqual(vm.stockDetails, stockDetailsData, "The response from our networking mock should match")
        
    }

}
