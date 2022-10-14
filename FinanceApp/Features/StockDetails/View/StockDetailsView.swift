//
//  StockView.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/11/22.
//

import SwiftUI

struct StockDetailsView: View {
    
    let symbol: String
    @StateObject private var vm: StockDetailsViewModel
    
    init(symbol: String) {
        self.symbol = symbol
        _vm = StateObject(wrappedValue: StockDetailsViewModel())
    }
}

extension StockDetailsView {
    var body: some View {
        VStack {
            
            ScrollView {
                if vm.isLoading {
                    ProgressView()
                } else {
                    // Stock Name
                    Text(vm.stockDetails?.quoteType?.shortName ?? "--")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Running Price
                    ZStack {
                        HStack {
                            Text(vm.stockDetails?.price?.regularMarketPrice?.fmt ?? "--")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .frame(alignment: .leading)
                            Text("USD")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 12.5)
                                .padding(.leading, -3)
                        }
                        let percentValue = vm.percentageDiff(lastClosed: vm.stockDetails?.summaryDetail?.previousClose?.raw ?? 0.0,
                                                             runningPrice: vm.stockDetails?.summaryDetail?.regularMarketOpen?.raw ?? 0.0)
                        
                        Text(Double(percentValue) ?? 0.0 > 0 ? "+\(percentValue)%" : "\(percentValue)%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 12.5)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Double(percentValue) ?? 0.0 >= 0 ? .green : .red)
                    }
                    Spacer()
                    Spacer()
                    
                    Group {
                        HStack {
                            Text("Previous Close:")
                            Spacer()
                            Text(vm.stockDetails?.summaryDetail?.previousClose?.fmt ?? "--")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding(.top, -3)
                        
                        
                        HStack {
                            Text("Open:")
                            Spacer()
                            Text(vm.stockDetails?.summaryDetail?.regularMarketOpen?.fmt ?? "--")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding(.top, -3)
                        
                        HStack {
                            Text("Volume:")
                            Spacer()
                            Text(vm.stockDetails?.summaryDetail?.regularMarketVolume?.fmt ?? "--")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding(.top, -3)
                        
                        HStack {
                            Text("Avg. Volume(3M):")
                            Spacer()
                            Text(vm.stockDetails?.price?.averageDailyVolume3Month?.fmt ?? "--")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding(.top, -3)
                        
                        HStack {
                            Text("Market Cap:")
                            Spacer()
                            Text(vm.stockDetails?.price?.marketCap?.fmt ?? "--")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding(.top, -3)
                    }
                    
                }
            }
            .padding()
        }
        .navigationBarTitle(vm.stockDetails?.symbol ?? "", displayMode: .inline)
        .task {
            await vm.fetchStockDetails(for: symbol)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button("Retry") {
                Task {
                    await vm.fetchStockDetails(for: symbol)
                }
            }
        }
        .embedInNavigation()
    }
}

struct StockView_Previews: PreviewProvider {
    
    private static var previewSymbol: String {
        let stocks = try! StaticJSONMapper.decode(file: "marketList",
                                                  type: MarketListModel.self)
        return stocks.marketSummaryAndSparkResponse.result.first!.symbol
    }
    
    static var previews: some View {
        StockDetailsView(symbol: previewSymbol)
            .embedInNavigation()
        
    }
}
