//
//  TradeSummary.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import SwiftUI

struct TradeSummaryView: View {
    let tradeGroup: TradeGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(tradeGroup.trades.first?.contractName ?? "Unknown Contract")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(formattedDate(tradeGroup.trades.first?.tradeDay ?? Date()))
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            entriesAndExits
        }
    }
    
    private var entriesAndExits: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Entries and Exits")
                .font(.headline)
            
            ForEach(organizedTrades) { trade in
                tradeSummaryRow(for: trade)
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func tradeSummaryRow(for trade: Trade) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Entry
            tradeRowDetail(time: trade.enteredAt, type: trade.type, size: trade.size, price: trade.entryPrice)
            
            // Exit (if applicable)
            if trade.exitedAt > trade.enteredAt {
                tradeRowDetail(time: trade.exitedAt, type: "Exit", size: trade.size, price: trade.exitPrice)
            }
            
            // Additional trade details
            tradeDetails(for: trade)
        }
    }
    
    private func tradeRowDetail(time: Date, type: String, size: Double, price: Double) -> some View {
        HStack {
            Text(formattedTime(time))
                .padding(.horizontal, 10)
            Spacer()
            Text(type)
                .foregroundColor(type == "Buy" ? .green : .red)
            Text("\(String(format: "%.2f", size))")
            Text("@")
            Text(String(format: "$%.2f", price))
        }
        .opacity(0.6)
        .font(.subheadline)
        .padding(.bottom, 4)
    }
    
    private func tradeDetails(for trade: Trade) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            detailRow(label: "Instrument:", value: trade.instrumentType)
            detailRow(label: "Position Type:", value: trade.type == "Long" ? "Long" : "Short")
            detailRow(label: "Total P&L:", value: String(format: "$%.2f", totalPnL))
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
            Text(value)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var totalPnL: Double {
        tradeGroup.trades.reduce(0) { $0 + $1.pnl }
    }
    
    private var organizedTrades: [Trade] {
        tradeGroup.trades.sorted { $0.enteredAt < $1.enteredAt }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
