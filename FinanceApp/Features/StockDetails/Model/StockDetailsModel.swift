//
//  StockDetailsModel.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/11/22.
//

import Foundation

// MARK: - StockDetailsModel
struct StockDetailsModel: Codable, Equatable {
    let price: Price?
    let quoteType: QuoteType?
    let summaryDetail: SummaryDetail?
    let symbol: String?
    static func == (lhs: StockDetailsModel, rhs: StockDetailsModel) -> Bool {
        true
    }
}

// MARK: - QuoteType
struct QuoteType: Codable {
    let shortName: String?
}

// MARK: - Price
struct Price: Codable {
    let averageDailyVolume3Month: AverageDailyVolume10Day?
    let regularMarketPrice: RegularMarketChange?
    let marketCap: AverageDailyVolume10Day?
}

// MARK: - AverageDailyVolume10Day
struct AverageDailyVolume10Day: Codable {
    let raw: Int?
    let fmt, longFmt: String?
}

// MARK: - RegularMarketChange
struct RegularMarketChange: Codable {
    let raw: Double?
    let fmt: String?
}

// MARK: - SummaryDetail
struct SummaryDetail: Codable {
    let previousClose, regularMarketOpen: RegularMarketChange?
    let regularMarketVolume: AverageDailyVolume10Day?
}

