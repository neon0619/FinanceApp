//
//  StockDetailsViewModelFailureTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/14/22.
//

import XCTest
@testable import FinanceApp

final class StockDetailsViewModelFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: StockDetailsViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerStockDetailsFailureMock()
        vm = StockDetailsViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        
        XCTAssertFalse(vm.isLoading, "The view model should not be loading")
        defer {
            XCTAssertFalse(vm.isLoading, "The view model should not be loading")
        }
        await vm.fetchStockDetails(for: "BTC-USD")
        
        XCTAssertTrue(vm.hasError, "The view model error should be true")
        XCTAssertNotNil(vm.hasError, "The view model error should not be nil")
        
    }

}
