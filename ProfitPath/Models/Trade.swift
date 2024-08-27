//
//  Trade.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import Foundation
import SwiftData

@Model
class TradeGroup: Encodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case isManuallyGrouped
        case accountID
        case journalEntryID
        case trades
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(isManuallyGrouped, forKey: .isManuallyGrouped)
        try container.encode(account?.id, forKey: .accountID)
        try container.encode(journalEntry?.id, forKey: .journalEntryID)
        try container.encode(trades.map { $0.id.uuidString }, forKey: .trades)
    }
}


@Model
class Trade: Encodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case instrumentType
        case contractName
        case enteredAt
        case exitedAt
        case entryPrice
        case exitPrice
        case fees
        case pnl
        case size
        case tradeDay
        case type
        case tradeGroupID
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(instrumentType, forKey: .instrumentType)
        try container.encode(contractName, forKey: .contractName)
        try container.encode(enteredAt, forKey: .enteredAt)
        try container.encode(exitedAt, forKey: .exitedAt)
        try container.encode(entryPrice, forKey: .entryPrice)
        try container.encode(exitPrice, forKey: .exitPrice)
        try container.encode(fees, forKey: .fees)
        try container.encode(pnl, forKey: .pnl)
        try container.encode(size, forKey: .size)
        try container.encode(tradeDay, forKey: .tradeDay)
        try container.encode(type, forKey: .type)
        try container.encode(tradeGroup?.id, forKey: .tradeGroupID)
    }
}
