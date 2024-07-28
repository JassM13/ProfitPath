//
//  TradeJournal.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import SwiftData
import Foundation

class TradeJournal: ObservableObject {
    static var shared = TradeJournal()
    
    private var modelContainer: ModelContainer
    private var context: ModelContext
    
    @Published var trades: [Trade] = []
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Trade.self)
            context = ModelContext(modelContainer)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
        
        trades = getAllTrades()
    }
    
    func addTrade(_ trade: Trade) {
        // Check if a trade with the same ID already exists
        let existingTrade = trades.first { $0.id == trade.id }
        
        if existingTrade == nil {
            context.insert(trade)
            trades.append(trade)
            saveContext()
        } else {
            print("Trade with ID \(trade.id) already exists. Skipping.")
        }
    }
    
    func getAllTrades() -> [Trade] {
        do {
            let descriptor = FetchDescriptor<Trade>(sortBy: [SortDescriptor(\.tradeDay, order: .reverse)])
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch trades: \(error.localizedDescription)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func importTrades(from fileURL: URL) {
        if let parsedTrades = CSVParser.parse(fileURL: fileURL) {
            for trade in parsedTrades {
                addTrade(trade)
            }
        }
    }
    
    func deleteTrade(_ trade: Trade) {
        context.delete(trade)
        if let index = trades.firstIndex(where: { $0.id == trade.id }) {
            trades.remove(at: index)
        }
        saveContext()
    }
    
    // Additional methods for filtering and analyzing trades
    func getTradesByDate(start: Date, end: Date) -> [Trade] {
        let descriptor = FetchDescriptor<Trade>(
            predicate: #Predicate { $0.tradeDay >= start && $0.tradeDay <= end },
            sortBy: [SortDescriptor(\.tradeDay)]
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch trades by date range: \(error.localizedDescription)")
            return []
        }
    }
    
    func calculateTotalPnL() -> Double {
        let trades = getAllTrades()
        return trades.reduce(0) { $0 + $1.pnl }
    }
}
