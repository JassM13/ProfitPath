//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var accountManager = AccountManager.shared
    @StateObject private var chartDetailManager = ChartDetailManager.shared
    
    @State private var totalProfit: Double = 0.0
    @State private var progressValue: Double = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        GeometryReader { geometry in
                            ZStack {
                                // Use the geometry proxy to get the frame size
                                CurvedLineChart(data: ProfitPath.dailyProfits(trades: accountManager.selectedAccount.trades), frame: geometry.frame(in: .local))
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .mask(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                                
                                if chartDetailManager.isTouching {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Text(chartDetailManager.detailText)
                                                .font(.system(size: 14, weight: .medium))
                                                .padding(12) // Increased padding for better spacing
                                                .background(Color.black.opacity(0.8))
                                                .foregroundColor(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10)) // Increased corner radius for a smoother look
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
            
            HStack {
                Text("Total Profit")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                SlotMachineText(value: totalProfit, animationDuration: 1)
                    .onAppear {
                        totalProfit = Double(formattedTotalProfit()) ?? 0
                    }
                    .onChange(of: accountManager.selectedAccount.trades) {
                        withAnimation(.easeInOut(duration: 1)) {
                            totalProfit = Double(formattedTotalProfit()) ?? 0
                        }
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.025))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            )
            
            ZStack() {
                HStack {
                    VStack(alignment: .leading) {
                        StatsCell(icon: "graph-up", iconColor: Color.accentColor, title: "Best Day", value: formattedBestDayProfit())
                        StatsCell(icon: "target", iconColor: Color.accentColor, title: "Accuracy", value: String(format: "%.2f%%", calculatedWinRate()), isSystemIcon: true)
                            .padding(.top, 5)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        StatsCell(icon: "graph-down", iconColor: Color.red, title: "Worst Day", value: formattedWorstDayLoss())
                        StatsCell(icon: "R:R", iconColor: Color.red, title: "R:R", value: String(format: "2.2"))
                            .padding(.top, 5)
                    }
                }
                .padding(.all)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.025)))
                Spacer()
            }
            
            ZStack {
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
                .onChange(of: accountManager.selectedAccount.trades) {
                    withAnimation(.linear(duration: 1)) {
                        progressValue = Double(formattedTotalProfit()) ?? 0
                    }
                }
            }
        }
        .padding([.horizontal])
        Spacer()
    }
    
    // Private helper functions for calculations
    private func formattedTotalProfit() -> String {
        let totalProfit = accountManager.selectedAccount.trades.reduce(0) { $0 + $1.pnl }
        return String(format: "%.2f", totalProfit)
    }
    
    private func formattedBestDayProfit() -> String {
        guard let bestDayProfit = dailyProfits().max(by: { $0.value < $1.value })?.value else { return "$0.00" }
        return String(format: "$%.2f", bestDayProfit)
    }
    
    private func formattedWorstDayLoss() -> String {
        guard let worstDayLoss = dailyProfits().min(by: { $0.value < $1.value })?.value else { return "$0.00" }
        return String(format: "$%.2f", worstDayLoss)
    }
    
    private func calculatedWinRate() -> Double {
        let totalTrades = accountManager.selectedAccount.trades.count
        let winningTrades = accountManager.selectedAccount.trades.filter { $0.pnl > 0 }.count
        return totalTrades > 0 ? (Double(winningTrades) / Double(totalTrades)) * 100 : 0.0
    }
    
    private func dailyProfits() -> [Date: Double] {
        var profitsByDay: [Date: Double] = [:]
        let trades = accountManager.selectedAccount.trades
        
        for trade in trades {
            let day = Calendar.current.startOfDay(for: trade.tradeDay)
            profitsByDay[day, default: 0] += trade.pnl
        }
        
        return profitsByDay
    }
}

struct SlotMachineText: View {
    let value: Double
    let animationDuration: Double
    
    @State private var animatedValue: Double = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        Text("$\(String(format: "%.2f", animatedValue))")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .onChange(of: value) {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        timer?.invalidate() // Invalidate the previous timer if any
        
        let startValue = animatedValue
        let endValue = value
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(animationDuration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            let currentTime = Date()
            let progress = min(max((currentTime.timeIntervalSince(startTime) / animationDuration), 0), 1)
            let interpolatedValue = startValue + (endValue - startValue) * progress
            animatedValue = interpolatedValue
            
            if currentTime >= endTime {
                animatedValue = endValue
                timer?.invalidate()
                timer = nil
            }
        }
    }
}


func dailyProfits(trades: [Trade]) -> [ChartData] {
    var profitByDay: [Date: Double] = [:]
    
    // Aggregate profits by date
    for trade in trades {
        let day = Calendar.current.startOfDay(for: trade.tradeDay)
        profitByDay[day, default: 0] += trade.pnl
    }
    
    // Sort the days and calculate the cumulative profit
    let sortedDates = profitByDay.keys.sorted()
    var cumulativeProfit: Double = 0
    var dailyCumulativeProfits: [ChartData] = []
    
    for date in sortedDates {
        cumulativeProfit += profitByDay[date] ?? 0
        dailyCumulativeProfits.append(ChartData(date: date, value: cumulativeProfit))
    }
    
    return dailyCumulativeProfits
}



#Preview {
    DashboardView()
}
