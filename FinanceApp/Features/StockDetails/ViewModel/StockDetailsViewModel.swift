//
//  StockDetailsViewModel.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/11/22.
//

import Foundation

final class StockDetailsViewModel: ObservableObject {
    
    @Published private(set) var stockDetails: StockDetailsModel!
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading = false
    @Published var hasError: Bool = false

    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    @MainActor
    func fetchStockDetails(for symbol: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await networkingManager.request(session: .shared,
                                                                    .stock(symbol: symbol),
                                                                    type: StockDetailsModel.self)
            self.stockDetails = response
            
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(err: error)
            }
        }
    }
    
    func percentageDiff(lastClosed: Double, runningPrice: Double) -> String {
        let priceDiffPercentage = (lastClosed - runningPrice) / 100
        let rounded = round(priceDiffPercentage * 1000) / 1000.0
        return "\(rounded)"
    }

    
}

extension StockDetailsViewModel {
    enum ViewState {
        case loading
        case fetching
        case finished
    }
}
