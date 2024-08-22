//
//  TradesView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/27/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct TradesView: View {
    @ObservedObject var navigationController = NavigationController.shared
    
    @StateObject private var accountManager = AccountManager.shared
    @State private var showingAddTradeSheet = false
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
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
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
                
                Button(action: {
                    showingAddTradeSheet.toggle()
                }) {
                    Text("Add Trade")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .sheet(isPresented: $showingAddTradeSheet) {
                AddTradeView()
            }
            .padding(.horizontal)

            ForEach(accountManager.selectedAccount.tradeGroups.sorted(by: { $0.createdAt > $1.createdAt })) { tradeGroup in
                Button(action: {
                    NavigationController.shared.updateCurrentView(
                        AnyView(DetailedTradeView(tradeGroup: tradeGroup)),
                        viewName: "Trades",
                        transition: .slide
                    )
                }) {
                    TradeCell(tradeGroup: tradeGroup, onDelete: {
                        accountManager.deleteTradeGroup(tradeGroup)
                    })
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

struct TradeCell: View {
    let tradeGroup: TradeGroup
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(tradeGroup.trades.first?.contractName ?? "Unknown Contract")
                    .font(.headline)
                Spacer()
                TradeTypeBadge(type: tradeGroup.trades.first?.type ?? "Unknown")
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: totalProfit >= 0 ? "arrow.up.right" : "arrow.down.right")
                    Text(String(format: "$%.2f", totalProfit))
                }
                .font(.headline)
                .foregroundColor(totalProfit >= 0 ? .green : .red)
                Spacer()
                Text("Created At: \(formattedDate(tradeGroup.createdAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    private var totalProfit: Double {
        tradeGroup.trades.reduce(0) { $0 + $1.pnl }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
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

#Preview {
    TradesView()
}
