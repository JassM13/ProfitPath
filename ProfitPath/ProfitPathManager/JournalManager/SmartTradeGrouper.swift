//
//  SmartTradeGrouper.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/3/24.
//

import Foundation

class SmartTradeGrouper: ObservableObject {
    private let timeThreshold: TimeInterval = 1800 // 30 minutes
    private let priceThreshold: Double = 0.02 // 2% price difference
    private let scalpingDurationThreshold: TimeInterval = 300  // 5 minutes
    private let scalpingPriceRangeThreshold: Double = 0.005    // 0.5%
    @Published var smartGrouping: Bool = true {
            didSet {
                print(smartGrouping)
            }
        }
    
    func groupTrades(_ trades: [Trade]) -> [TradeGroup] {
        if !smartGrouping {
            return trades.map { TradeGroup(trades: [$0], groupType: analyzeTrade($0), journal: Journal()) }
        }
        
        let sortedTrades = trades.sorted { $0.enteredAt < $1.enteredAt }
        var groups: [TradeGroup] = []
        var currentGroup: [Trade] = []
        
        for trade in sortedTrades {
            if let lastTrade = currentGroup.last,
               isSimilarTrade(trade, lastTrade) {
                currentGroup.append(trade)
            } else {
                if !currentGroup.isEmpty {
                    groups.append(createTradeGroup(currentGroup))
                }
                currentGroup = [trade]
            }
        }
        
        if !currentGroup.isEmpty {
            groups.append(createTradeGroup(currentGroup))
        }
        
        return groups
    }
    
    private func isSimilarTrade(_ trade1: Trade, _ trade2: Trade) -> Bool {
        return trade1.contractName == trade2.contractName &&
               trade1.type == trade2.type &&
               abs(trade1.enteredAt.timeIntervalSince(trade2.enteredAt)) < timeThreshold &&
               abs(trade1.entryPrice - trade2.entryPrice) / trade2.entryPrice < priceThreshold
    }
    
    private func createTradeGroup(_ trades: [Trade]) -> TradeGroup {
        let groupType: GroupType
        if trades.count == 1 {
            groupType = analyzeTrade(trades[0])
        } else if trades.allSatisfy({ analyzeTrade($0) == .scalping }) {
            groupType = .scalping
        } else {
            groupType = .groupedTrade
        }
        
        return TradeGroup(trades: trades, groupType: groupType, journal: Journal())
    }
    
    private func analyzeTrade(_ trade: Trade) -> GroupType {
        let duration = trade.exitedAt.timeIntervalSince(trade.enteredAt)
        let priceRangePercentage = abs(trade.exitPrice - trade.entryPrice) / trade.entryPrice
        
        if duration <= scalpingDurationThreshold && priceRangePercentage <= scalpingPriceRangeThreshold {
            return .scalping
        }
        
        return .normal
    }
}
