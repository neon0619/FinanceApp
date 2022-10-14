//
//  MarketListView.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/10/22.
//

import SwiftUI

struct MarketListView: View {
    @State private var query = ""
    
    var body: some View {
        SearchedView(query: query)
            .searchable(text: $query)
            .embedInNavigation()
    }
}

struct SearchedView: View {
    let query: String
    @StateObject private var vm: MarketListViewModel
    @Environment(\.isSearching) private var isSearching
    
    init(query: String) {
        self.query = query
        _vm = StateObject(wrappedValue: MarketListViewModel())
    }
}

extension SearchedView {
    var body: some View {
        VStack {
            if vm.marketResults.isEmpty {
                ProgressView("Loading")
            } else {
                List {
                    ForEach(vm.filteredResult, id: \.symbol) { stock in
                        NavigationLink {
                            StockDetailsView(symbol: stock.symbol)
                        } label: {
                            MarketListItems(stock: stock, vm: vm)
                        }
                    }
                }
                .onReceive(vm.timer) { _ in
                    Task {
                        await vm.fetchMarketList()
                        vm.search()
                    }
                }
                .onAppear() {
                    vm.startTimer()
                }
                .onDisappear() {
                    vm.stopTimer()
                }
            }
        }
        .task {
            await vm.fetchMarketList()
            vm.search()
        }
        .navigationTitle("Markets")
        .onChange(of: query) { newQuery in
            vm.search(with: newQuery)
            isSearching ? vm.stopTimer() : vm.startTimer()
        }
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button("Retry") {
                Task {
                    await vm.fetchMarketList()
                }
            }
        }
    }
}

struct MarketListView_Previews: PreviewProvider {
    static var previews: some View {
        MarketListView()
    }
}

