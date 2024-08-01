//
//  TradesView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct TradesView: View {
    @StateObject private var accountManager = AccountManager.shared
    
    @State private var isFileImporterPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isFileImporterPresented = true
                }) {
                    Text("Import Trades")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // Make the button take as much space as possible
                .fileImporter(
                    isPresented: $isFileImporterPresented,
                    allowedContentTypes: [UTType.commaSeparatedText],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        if let url = urls.first {
                            accountManager.importTrades(from: url)
                        }
                    case .failure(let error):
                        print("Failed to import file: \(error.localizedDescription)")
                    }
                }
                
                Button(action: {}) {
                    Text("Add Trade")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundStyle(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // Make the button take as much space as possible
            }
            .padding(.horizontal)

            
            ForEach(accountManager.selectedAccount.trades) { trade in
                TradeCell(trade: trade, onDelete: {
                    accountManager.deleteTrade(trade)
                })
                .padding(.bottom, 10)
            }
        }
        .padding()
    }
}

struct TradeCell: View {
    let trade: Trade
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(trade.contractName)
                    .font(.headline)
                Spacer()
                TradeTypeBadge(type: trade.type)
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            TradeInfoRow(title: "Entered", value: formattedTime(trade.enteredAt))
            TradeInfoRow(title: "Exited", value: formattedTime(trade.exitedAt))
            TradeInfoRow(title: "Entry Price", value: formattedPrice(trade.entryPrice))
            TradeInfoRow(title: "Exit Price", value: formattedPrice(trade.exitPrice))
            TradeInfoRow(title: "Size", value: formattedDecimal(trade.size))
            TradeInfoRow(title: "Fees", value: formattedPrice(trade.fees))
            
            HStack {
                PnLView(pnl: trade.pnl)
                Spacer()
                Text("Trade Day: \(formattedDate(trade.tradeDay))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
    
    private func formattedDecimal(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
}

struct TradeInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct TradeTypeBadge: View {
    let type: String
    
    var body: some View {
        Text(type)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(type == "Buy" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            .foregroundColor(type == "Buy" ? .green : .red)
            .cornerRadius(20)
    }
}

struct PnLView: View {
    let pnl: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: pnl >= 0 ? "arrow.up.right" : "arrow.down.right")
            Text(formattedPnL)
        }
        .font(.headline)
        .foregroundColor(pnl >= 0 ? .green : .red)
    }
    
    private var formattedPnL: String {
        let absValue = abs(pnl)
        return String(format: "$%.2f", absValue)
    }
}

#Preview {
    TradesView()
}
