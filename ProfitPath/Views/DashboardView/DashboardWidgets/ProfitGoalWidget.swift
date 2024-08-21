//
//  ProfitGoalWidget.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/19/24.
//

import SwiftUI

struct ProfitGoalView: View {
    @StateObject private var accountManager = AccountManager.shared
    @State private var progressValue: Double = 0.0
    
    var body: some View {
        ProgressView(value: progressValue, total: 3000, label: {
            Text("Profit Goal")
                .font(.headline)
                .foregroundColor(.white)
        }, currentValueLabel: {
            Text("$\(formattedTotalProfit())/3000")
                .font(.subheadline)
                .foregroundColor(.gray)
        })
        .padding(.all)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.025))
        )
        .progressViewStyle(LinearProgressViewStyle())
        .onAppear {
            withAnimation(.linear(duration: 1)) {
                progressValue = Double(formattedTotalProfit()) ?? 0
            }
        }
    }
    
    private func formattedTotalProfit() -> String {
        let totalProfit = accountManager.selectedAccount.tradeGroups
            .flatMap { $0.trades } // Flatten trades from all TradeGroups
            .reduce(0) { $0 + $1.pnl } // Sum up the pnl values of all trades
        return String(format: "%.2f", totalProfit) // Format the total profit as a string
    }
}
