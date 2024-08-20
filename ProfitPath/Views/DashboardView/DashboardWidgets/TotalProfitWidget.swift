//
//  TotalProfitWidget.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/19/24.
//

import SwiftUI

struct TotalProfitView: View {
    @StateObject private var accountManager = AccountManager.shared
    @State private var totalProfit: Double = 0.0
    
    var body: some View {
        HStack {
            Text("Total Profit")
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            SlotMachineText(value: totalProfit, animationDuration: 1)
                .onAppear {
                    totalProfit = Double(formattedTotalProfit()) ?? 0
                }
                .onChange(of: accountManager.selectedAccount.tradeGroups) {
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
    }
    
    private func formattedTotalProfit() -> String {
        let totalProfit = accountManager.selectedAccount.tradeGroups
            .flatMap { $0.trades }
            .reduce(0) { $0 + $1.pnl }
        
        return String(format: "%.2f", totalProfit)
    }

    
    private struct SlotMachineText: View {
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
}
