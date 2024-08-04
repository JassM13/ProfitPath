//
//  JournalManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/3/24.
//

import Foundation
import Combine
import SwiftData

class JournalManager: ObservableObject {
    static let shared = JournalManager()
    
    public var smartTradeGrouper: SmartTradeGrouper = SmartTradeGrouper()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        smartTradeGrouper.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }
    
    func createJournalEntries(trades: [Trade], isGroupingEnabled: Bool) -> [TradeGroup] {
        return smartTradeGrouper.groupTrades(trades)
    }
    
    func addNotes(to tradeGroup: TradeGroup, notes: String) {
        tradeGroup.journal.notes = notes
    }
    
    func addImage(to tradeGroup: TradeGroup, imageData: Data) {
        tradeGroup.journal.images.append(imageData)
    }
    
    func generateMarkdownReport(for tradeGroup: TradeGroup) -> String {
        var markdown = "# Trade Group Report\n\n"
        markdown += "**Contract:** \(tradeGroup.contractName)\n"
        markdown += "**Type:** \(tradeGroup.type)\n"
        markdown += "**Entered:** \(formatDate(tradeGroup.enteredAt))\n"
        markdown += "**Exited:** \(formatDate(tradeGroup.exitedAt))\n"
        markdown += "**Total Size:** \(tradeGroup.totalSize)\n"
        markdown += "**Entry Price:** \(formatPrice(tradeGroup.entryPrice))\n"
        markdown += "**Exit Price:** \(formatPrice(tradeGroup.exitPrice))\n"
        markdown += "**Total Fees:** \(formatPrice(tradeGroup.totalFees))\n"
        markdown += "**Total P&L:** \(formatPrice(tradeGroup.totalPnL))\n"
        markdown += "**Group Type:** \(tradeGroup.groupType.rawValue)\n\n"
        
        if tradeGroup.trades.count > 1 {
            markdown += "## Individual Trades\n\n"
            for (index, trade) in tradeGroup.trades.enumerated() {
                markdown += "### Trade \(index + 1)\n"
                markdown += "**Entered:** \(formatDate(trade.enteredAt))\n"
                markdown += "**Exited:** \(formatDate(trade.exitedAt))\n"
                markdown += "**Size:** \(trade.size)\n"
                markdown += "**Entry Price:** \(formatPrice(trade.entryPrice))\n"
                markdown += "**Exit Price:** \(formatPrice(trade.exitPrice))\n"
                markdown += "**Fees:** \(formatPrice(trade.fees))\n"
                markdown += "**P&L:** \(formatPrice(trade.pnl))\n\n"
            }
        }
        
        if !tradeGroup.journal.notes.isEmpty {
            markdown += "## Notes\n\n\(tradeGroup.journal.notes)\n\n"
        }
        
        if !tradeGroup.journal.images.isEmpty {
            markdown += "## Images\n\n"
            for (index, _) in tradeGroup.journal.images.enumerated() {
                markdown += "![Image \(index + 1)](image_\(index + 1))\n"
            }
        }
        
        return markdown
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatPrice(_ price: Double) -> String {
        return String(format: "%.2f", price)
    }
}
