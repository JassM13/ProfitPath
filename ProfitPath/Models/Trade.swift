//
//  Trade.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import Foundation

class TradeGroup: Identifiable, Equatable {
    var id: UUID
    var trades: [Trade] = []
    var journalEntry: JournalEntry?
    var createdAt: Date
    var isManuallyGrouped: Bool

    init(id: UUID = UUID(), trades: [Trade] = [], journalEntry: JournalEntry? = nil, createdAt: Date = Date(), isManuallyGrouped: Bool = false) {
        self.id = id
        self.trades = trades
        self.journalEntry = journalEntry
        self.createdAt = createdAt
        self.isManuallyGrouped = isManuallyGrouped
    }
    
    static func == (lhs: TradeGroup, rhs: TradeGroup) -> Bool {
        return lhs.id == rhs.id
    }
}

class Trade: Identifiable {
    var id: UUID
    var contractName: String
    var enteredAt: Date
    var exitedAt: Date
    var entryPrice: Double
    var exitPrice: Double
    var fees: Double
    var pnl: Double
    var size: Double
    var type: String
    var instrumentType: String
    var tradeDay: Date
    
    var tradeGroup: TradeGroup?

    init(id: UUID = UUID(), contractName: String, enteredAt: Date, exitedAt: Date, entryPrice: Double, exitPrice: Double, fees: Double, pnl: Double, size: Double, type: String, instrumentType: String, tradeDay: Date) {
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
        self.instrumentType = instrumentType
        self.tradeDay = tradeDay
    }
}
