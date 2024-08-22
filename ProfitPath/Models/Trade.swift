//
//  Trade.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import Foundation
import SwiftData

@Model
class TradeGroup {
    var id: UUID
    var createdAt: Date
    var isManuallyGrouped: Bool
    @Attribute(.externalStorage)
    var account: Account?
    @Attribute(.externalStorage)
    var journalEntry: JournalEntry?
    @Relationship(deleteRule: .cascade, inverse: \Trade.tradeGroup)
    var trades: [Trade] = []
    
    init(id: UUID = UUID(), createdAt: Date = Date(), isManuallyGrouped: Bool = false, trades: [Trade] = []) {
        self.id = id
        self.createdAt = createdAt
        self.isManuallyGrouped = isManuallyGrouped
        self.trades = trades
    }
}

@Model
class Trade {
    var id: UUID
    var instrumentType: String
    var contractName: String
    var enteredAt: Date
    var exitedAt: Date
    var entryPrice: Double
    var exitPrice: Double
    var fees: Double
    var pnl: Double
    var size: Double
    var tradeDay: Date
    var type: String
    @Attribute(.externalStorage)
    var tradeGroup: TradeGroup?
    
    init(id: UUID = UUID(), contractName: String, enteredAt: Date, entryPrice: Double = 0.0,
         exitedAt: Date, exitPrice: Double = 0.0, fees: Double = 0.0, instrumentType: String,
         pnl: Double = 0.0, size: Double = 0.0, tradeDay: Date, type: String) {
        self.id = id
        self.contractName = contractName
        self.enteredAt = enteredAt
        self.entryPrice = entryPrice
        self.exitedAt = exitedAt
        self.exitPrice = exitPrice
        self.fees = fees
        self.instrumentType = instrumentType
        self.pnl = pnl
        self.size = size
        self.tradeDay = tradeDay
        self.type = type
    }
}
