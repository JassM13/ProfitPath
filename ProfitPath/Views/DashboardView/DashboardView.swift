//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    // Assuming your sample data is updated to include day and moneyValue
    let samples: [Sample] = [
        // Example data:
        Sample(id: UUID(), day: 1, x: 0.5, y: 100, moneyValue: 100),
        Sample(id: UUID(), day: 2, x: 0.2, y: 150, moneyValue: 150),
        Sample(id: UUID(), day: 3, x: 0.8, y: 80, moneyValue: 80),
        // ... add more data here
    ]

    var body: some View {
        let paddedMaxValue = samples.map { $0.moneyValue }.max() ?? 0 * 1.1
        Chart {
            ForEach(samples) { sample in
                LineMark(
                    x: .value("Day", sample.day),
                    y: .value("Money Value", sample.moneyValue)
                )
                .accessibilityLabel("\(sample.day)")
                .accessibilityValue("\(sample.moneyValue)")
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                //AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .currency(code: "USD"))
            }
        }
        .chartXAxis {
            AxisMarks() { value in
                //AxisGridLine()
                AxisTick()
                AxisValueLabel() // Default formatting will show the adjusted day
            }
        }
        .padding()
        .background(.mainColors.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(width: .infinity, height: 280)
        .padding(.horizontal)
        .navigationBarTitle("Profit Path", displayMode: .inline)
        Spacer(minLength: 300)
    }

    struct Sample: Identifiable {
        let id: UUID // Ensures unique identification
        var day: Int
        var x: Double // If not needed for the chart, you can remove this
        var y: Double // If not needed for the chart, you can remove this
        var moneyValue: Double
    }
}



#Preview {
    DashboardView()
}
