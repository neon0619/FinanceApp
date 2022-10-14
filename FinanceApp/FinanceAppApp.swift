//
//  FinanceAppApp.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/8/22.
//

import SwiftUI

@main
struct FinanceAppApp: App {
    var body: some Scene {
        WindowGroup {
            MarketListView()
//            StockDetailsView(symbol: "^DJI")
        }
    }
}
