//
//  MarketListModel.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/10/22.
//


import Foundation

// MARK: - MarketListModel
struct MarketListModel: Codable, Equatable {
    let marketSummaryAndSparkResponse: MarketSummaryAndSparkResponse
    static func == (lhs: MarketListModel, rhs: MarketListModel) -> Bool {
        true
    }
}

// MARK: - MarketSummaryAndSparkResponse
struct MarketSummaryAndSparkResponse: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let symbol: String
    let fullExchangeName: String
    let shortName: String?
    let spark: Spark
    
}

// MARK: - Spark
struct Spark: Codable {
    let close: [Double]?
    let chartPreviousClose: Double
}


