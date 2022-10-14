//
//  MarketLIstViewModel.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/10/22.
//

import Foundation

final class MarketListViewModel: ObservableObject {
    
    @Published private(set) var marketResults: [Result] = []
    @Published private(set) var filteredResult = [Result]()
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError: Bool = false
    
    var timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    
    var isLoading: Bool { viewState == .loading }
    var isFetching: Bool { viewState == .fetching }
    
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    
    @MainActor
    func fetchMarketList() async {
        viewState = .loading
        defer { viewState = .finished }
        
        do {
            let response = try await networkingManager.request(session: .shared,
                                                               .market(region: "US"),
                                                               type: MarketListModel.self)
            self.marketResults = response.marketSummaryAndSparkResponse.result
            
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(err: error)
            }
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    func roundTo2Decimal(value: Double) -> String {
        let rounded = round(value * 100) / 100.0
        return "\(rounded)"
    }
    
    func percentageDiff(lastClosed: Double, runningPrice: Double) -> String {
        let priceDiffPercentage = (lastClosed - runningPrice) / 100
        let rounded = round(priceDiffPercentage * 100) / 100.0
        return "\(rounded)"
    }
    
    func search(with query: String = "") {
        filteredResult = query.isEmpty ? marketResults : marketResults.filter { $0.symbol.localizedCaseInsensitiveContains(query) }
    }
    
}

extension MarketListViewModel {
    enum ViewState {
        case loading
        case fetching
        case finished
    }
}
