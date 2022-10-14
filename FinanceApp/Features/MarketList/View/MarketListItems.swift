//
//  MarketListItems.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/14/22.
//

import SwiftUI

struct MarketListItems: View {

    let stock: Result
    let vm: MarketListViewModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(stock.symbol)")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(stock.shortName ?? "")")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(vm.roundTo2Decimal(value: stock.spark.close?.last ?? 0.0))
                    .font(.subheadline)
                    .fontWeight(.bold)
                let percentValue = vm.percentageDiff(lastClosed: stock.spark.chartPreviousClose, runningPrice: stock.spark.close?.last ?? 0.0)
                Text(Double(percentValue) ?? 0.0 >= 0 ? "+\(percentValue)%" : "\(percentValue)%")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Double(percentValue) ?? 0.0 >= 0 ? .green : .red)
                
            }
        }
    }
}
