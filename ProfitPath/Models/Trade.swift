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
