//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import Charts

struct DataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct DashboardView: View {
    @State private var dataPoints: [DataPoint] = [
        DataPoint(date: Date().addingTimeInterval(-86400 * 7), value: 0), // 7 days ago
        DataPoint(date: Date().addingTimeInterval(-86400 * 6), value: 600), // 6 days ago
        DataPoint(date: Date().addingTimeInterval(-86400 * 5), value: 950), // 5 days ago
        DataPoint(date: Date().addingTimeInterval(-86400 * 4), value: 800), // 4 days ago
        DataPoint(date: Date().addingTimeInterval(-86400 * 3), value: 700), // 3 days ago
        DataPoint(date: Date().addingTimeInterval(-86400 * 2), value: 1300), // 2 days ago
        DataPoint(date: Date().addingTimeInterval(-86400 * 1), value: 1250), // 1 day ago
        DataPoint(date: Date(), value: 1400), // today
    ]

    var body: some View {
        VStack {
            ZStack {
                AnimatedChartLine(samples: dataPoints, date: Date())
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(height: UIScreen.main.bounds.height / 3.8)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    StatsCell(title: "Profit %", value: String(format: "%.1f%%"))
                    StatsCell(title: "Risk to Reward", value: String(format: "%.1f"))
                    Spacer()
                }
                Spacer()
            }
        }
        .padding([.horizontal, .bottom])
    }
}

#Preview {
    DashboardView()
}
