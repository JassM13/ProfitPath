//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import UniformTypeIdentifiers
import Spectra

struct DashboardView: View {
    @State private var isFileImporterPresented = false
    @StateObject var tradeJournal = TradeJournal.shared
    @State private var totalProfit: Double = 0.0
    @State private var progressValue: Double = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        LineChartView(trades: sortedTradesByDate(trades: tradeJournal.trades))
                            .padding(.top)
                            .mask(
                                RoundedRectangle(cornerRadius: 8)
                            )
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
                    .onChange(of: tradeJournal.trades) {
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
                        StatsCell(icon: "graph-up", iconColor: Color.green, title: "Best Day", value: formattedBestDayProfit())
                        StatsCell(icon: "winrate", iconColor: Color.green, title: "WinRate", value: String(format: "%.2f%%", calculatedWinRate()))
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
                    Text("\(formattedTotalProfit())/3000")
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
                .onChange(of: tradeJournal.trades) {
                    withAnimation(.linear(duration: 1)) {
                        progressValue = Double(formattedTotalProfit()) ?? 0
                    }
                }
            }
            
            HStack {
                Button(action: {
                    isFileImporterPresented = true
                }) {
                    Text("Upload CSV File")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(Color.black)
                        .foregroundColor(.white)
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
                            tradeJournal.importTrades(from: url)
                        }
                    case .failure(let error):
                        print("Failed to import file: \(error.localizedDescription)")
                    }
                }
                
                Button(action: {}) {
                    Text("Add Trade")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .padding([.horizontal])
        Spacer()
    }
    
    // Private helper functions for calculations
    private func formattedTotalProfit() -> String {
        let totalProfit = tradeJournal.trades.reduce(0) { $0 + $1.pnl }
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
        let totalTrades = tradeJournal.trades.count
        let winningTrades = tradeJournal.trades.filter { $0.pnl > 0 }.count
        return totalTrades > 0 ? (Double(winningTrades) / Double(totalTrades)) * 100 : 0.0
    }
    
    private func dailyProfits() -> [Date: Double] {
        var profitsByDay: [Date: Double] = [:]
        let trades = tradeJournal.trades
        
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
    
    var body: some View {
        Text("$\(String(format: "%.2f", animatedValue))")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.green)
            .onAppear {
                withAnimation(.linear(duration: animationDuration)) {
                    animatedValue = value
                }
            }
            .onChange(of: value) {
                withAnimation(.linear(duration: animationDuration)) {
                    animatedValue = value
                }
            }
    }
}

func sortedTradesByDate(trades: [Trade]) -> [Trade] {
    return trades.sorted { $0.tradeDay < $1.tradeDay }
}


#Preview {
    DashboardView()
}
