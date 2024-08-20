//
//  ChartWidget.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/19/24.
//

import SwiftUI

struct ChartView: View {
    @StateObject private var accountManager = AccountManager.shared
    @StateObject private var chartDetailManager = ChartDetailManager.shared
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    GeometryReader { geometry in
                        ZStack {
                            CurvedLineChart(data: dailyProfits(accountManager.selectedAccount.tradeGroups), frame: geometry.frame(in: .local))
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .mask(RoundedRectangle(cornerRadius: 8))
                            
                            if chartDetailManager.isTouching {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(chartDetailManager.detailText)
                                            .font(.system(size: 14, weight: .medium))
                                            .padding(12)
                                            .background(Color.black.opacity(0.8))
                                            .foregroundColor(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .transition(.opacity)
                                    }
                                }
                                .padding(4)
                            }
                        }
                    }
                )
        }
        .frame(height: UIScreen.main.bounds.height / 3.8)
    }
    
    private func dailyProfits(_ tradeGroups: [TradeGroup]) -> [ChartData] {
        var profitByDay: [Date: Double] = [:]
        
        // Aggregate profits by date from all trades in all TradeGroups
        for group in tradeGroups {
            for trade in group.trades {
                let day = Calendar.current.startOfDay(for: trade.tradeDay)
                profitByDay[day, default: 0] += trade.pnl
            }
        }
        
        // Sort dates and calculate cumulative profit
        let sortedDates = profitByDay.keys.sorted()
        var cumulativeProfit: Double = 0
        var dailyCumulativeProfits: [ChartData] = []
        
        for date in sortedDates {
            cumulativeProfit += profitByDay[date] ?? 0
            dailyCumulativeProfits.append(ChartData(date: date, value: cumulativeProfit))
        }
        
        return dailyCumulativeProfits
    }
}
