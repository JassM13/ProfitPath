//
//  Trade.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import Foundation
import SwiftData

@Model
class Trade {
    var id: String
    var contractName: String
    var enteredAt: Date
    var exitedAt: Date
    var entryPrice: Double
    var exitPrice: Double
    var fees: Double
    var pnl: Double
    var size: Double
    var type: String
    var tradeDay: Date
    
    init(id: String, contractName: String, enteredAt: Date, exitedAt: Date, entryPrice: Double, exitPrice: Double, fees: Double, pnl: Double, size: Double, type: String, tradeDay: Date) {
        self.id = id
        self.contractName = contractName
        self.enteredAt = enteredAt
        self.exitedAt = exitedAt
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.fees = fees
        self.pnl = pnl
        self.size = size
        self.type = type
        self.tradeDay = tradeDay
    }
}

class TradeGroup: Identifiable {
    var id = UUID()
    let trades: [Trade]
    let contractName: String
    let enteredAt: Date
    let exitedAt: Date
    let entryPrice: Double
    let exitPrice: Double
    let totalSize: Double
    let totalFees: Double
    let totalPnL: Double
    let type: String
    let tradeDay: Date
    var groupType: GroupType
    var journal: Journal
    
    init(trades: [Trade], groupType: GroupType = .normal, journal: Journal) {
        self.id = UUID()
        self.trades = trades
        self.contractName = trades.first?.contractName ?? ""
        self.enteredAt = trades.map { $0.enteredAt }.min() ?? Date()
        self.exitedAt = trades.map { $0.exitedAt }.max() ?? Date()
        
        self.totalSize = trades.reduce(0) { $0 + $1.size }
        self.totalFees = trades.reduce(0) { $0 + $1.fees }
        self.totalPnL = trades.reduce(0) { $0 + $1.pnl }
        self.type = trades.first?.type ?? ""
        self.tradeDay = trades.first?.tradeDay ?? Date()
        self.groupType = groupType
        self.journal = journal
        
        
        // Calculate entry and exit prices
        if trades.count == 1 {
            self.entryPrice = trades[0].entryPrice
            self.exitPrice = trades[0].exitPrice
        } else {
            // For grouped trades, use first trade's entry and last trade's exit
            self.entryPrice = trades.first?.entryPrice ?? 0
            self.exitPrice = trades.last?.exitPrice ?? 0
        }
    }
}

enum GroupType: String, Codable {
    case normal
    case scalping
    case groupedTrade
    case unknown
}
