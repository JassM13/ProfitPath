//
//  StatsWidget.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/19/24.
//

import SwiftUI

struct StatsView: View {
    @StateObject private var accountManager = AccountManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                StatsCell(icon: "graph-up", iconColor: Color.accentColor, title: "Best Day", value: formattedBestDayProfit())
                StatsCell(icon: "target", iconColor: Color.accentColor, title: "Accuracy", value: String(format: "%.2f%%", calculatedWinRate()), isSystemIcon: true)
                    .padding(.top, 5)
            }
            Spacer()
            
            VStack(alignment: .leading) {
                StatsCell(icon: "graph-down", iconColor: Color.red, title: "Worst Day", value: formattedWorstDayLoss())
                StatsCell(icon: "R:R", iconColor: Color.red, title: "R:R", value: String(format: "%.2f", calculateRiskRewardRatio()))
            }
        }
        .padding(.all)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.025)))
    }
    
    // Private helper functions for calculations
    private func formattedBestDayProfit() -> String {
        guard let bestDayProfit = dailyProfits().max(by: { $0.value < $1.value })?.value else { return "$0.00" }
        return String(format: "$%.2f", bestDayProfit)
    }
    
    private func formattedWorstDayLoss() -> String {
        guard let worstDayLoss = dailyProfits().min(by: { $0.value < $1.value })?.value else { return "$0.00" }
        return String(format: "$%.2f", worstDayLoss)
    }
    
    private func calculatedWinRate() -> Double {
        // Fetch all trade groups from the selected account
        let tradeGroups = accountManager.selectedAccount.tradeGroups
        
        // Filter groups where at least one trade is a winning trade
        let totalGroups = tradeGroups.count
        let winningGroups = tradeGroups.filter { group in
            group.trades.contains { $0.pnl > 0 }
        }.count
        
        return totalGroups > 0 ? (Double(winningGroups) / Double(totalGroups)) * 100 : 0.0
    }

    
    private func dailyProfits() -> [Date: Double] {
        var profitsByDay: [Date: Double] = [:]
        
        // Fetch all trade groups from the selected account
        let tradeGroups = accountManager.selectedAccount.tradeGroups
        
        for group in tradeGroups {
            let day = Calendar.current.startOfDay(for: group.createdAt)
            // Sum up profits for each group for the given day
            let groupProfit = group.trades.reduce(0) { $0 + $1.pnl }
            profitsByDay[day, default: 0] += groupProfit
        }
        
        return profitsByDay
    }

    
    private func calculateRiskRewardRatio() -> Double {
        // Fetch all trade groups from the selected account
        let tradeGroups = accountManager.selectedAccount.tradeGroups
        
        // Flatten the trades from all trade groups
        let trades = tradeGroups.flatMap { $0.trades }
        
        // Filter winning and losing trades
        let winningTrades = trades.filter { $0.pnl > 0 }
        let losingTrades = trades.filter { $0.pnl < 0 }
        
        // Calculate average win
        let totalWinningPnl = winningTrades.reduce(0) { $0 + $1.pnl }
        let averageWin = winningTrades.isEmpty ? 0 : totalWinningPnl / Double(winningTrades.count)
        
        // Calculate average loss
        let totalLosingPnl = losingTrades.reduce(0) { $0 + $1.pnl }
        let averageLoss = losingTrades.isEmpty ? 0 : abs(totalLosingPnl / Double(losingTrades.count))
        
        // Return risk-reward ratio
        guard averageLoss != 0 else {
            return Double.infinity // Avoid division by zero
        }
        
        return averageWin / averageLoss
    }
}
