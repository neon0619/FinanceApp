//
//  MarketListViewModelFailureTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/13/22.
//

import XCTest
@testable import FinanceApp

final class MarketListViewModelFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: MarketListViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerMarketListFailureMock()
        vm = MarketListViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        
        XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
        defer {
            XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
            XCTAssertEqual(vm.viewState, .finished, "The viewModel viewState should be finished")
        }
        await vm.fetchMarketList()
        
        XCTAssertTrue(vm.hasError, "The view model should have an error")
        XCTAssertNotNil(vm.error, "The view model error should be set")
        
    }

}
