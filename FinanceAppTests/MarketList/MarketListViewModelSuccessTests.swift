//
//  MarketListViewModelSuccessTests.swift
//  FinanceAppTests
//
//  Created by Christopher Castillo on 10/13/22.
//

import XCTest
@testable import FinanceApp

final class MarketListViewModelSuccessTests: XCTestCase {

    private var networkingMock: NetworkingManagerImpl!
    private var vm: MarketListViewModel!
    
    override func setUp() {
        networkingMock = NetworkingManagerMarketListSuccessMock()
        vm = MarketListViewModel(networkingManager: networkingMock)
    }
    
    override func tearDown() {
        networkingMock = nil
        vm = nil
    }

    func test_with_sucessful_response_market_list_is_set() async throws {
        XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
        defer {
            XCTAssertFalse(vm.isLoading, "The view model shouldn't be loading any data")
            XCTAssertEqual(vm.viewState, .finished, "The viewModel viewState should be finished")
        }
        await vm.fetchMarketList()
        XCTAssertEqual(vm.marketResults.count, 16, "There should be 16 users within our data array")
    }
    
    func test_with_sucessful_response_market_list_every_8_seconds() async throws {
        
    }

}
