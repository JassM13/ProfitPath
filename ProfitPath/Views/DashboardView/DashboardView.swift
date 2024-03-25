//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    var body: some View {
        ScrollView { // Use a ScrollView for multiple charts
            ZStack() {
                HStack(spacing: 20) {
                    LineChartCard(title: "Profits",
                                  data: sampleRevenueData)

                    LineChartCard(title: "R:R",
                                  data: sampleExpenseData)
                }
                
            }
            .padding()
        }
    }
}

// Sample dataset
let sampleRevenueData: [ChartData] = [
    ChartData(date: Date.now.addingTimeInterval(-60*60*24*7), value: 1200),
    ChartData(date: Date.now.addingTimeInterval(-60*60*24*6), value: 1550),
    // ... more data points
]
let sampleExpenseData: [ChartData] = [
    ChartData(date: Date.now.addingTimeInterval(-60*60*24*7), value: 850),
    ChartData(date: Date.now.addingTimeInterval(-60*60*24*6), value: 700),
    // ... more data points
]

// Reusable card for the charts
struct LineChartCard: View {
    let title: String
    let data: [ChartData]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            Chart(data) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Value", $0.value)
                )
                .foregroundStyle(.blue) // Line color
            }
            .frame(height: 200)
        }
        .padding()
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

#Preview {
    DashboardView()
}
