//
//  AnimatedChartLIne.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/28/24.
//

import SwiftUI
import Charts

struct AnimatedChartLine: View, Animatable {
    var animatableData: Date
    
    let samples: [DataPoint]
    
    init(samples: [DataPoint], date: Date) {
        self.animatableData = date
        self.samples = samples
        self.animatableData = samples.last?.date ?? Date()
    }
    
    var body: some View {
        Chart {
            ForEach(samples) { sample in
                LineMark(
                    x: .value("Date", sample.date),
                    y: .value("Value", sample.value)
                )
                .accessibilityLabel("\(sample.date)")
                .accessibilityValue("\(sample.value)")
            }
            
            PointMark(
                x: .value("Date", animatableData),
                y: .value("Value", findValueForDate(date: animatableData))
            )
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
    
    func findValueForDate(date: Date) -> Double {
        // Implement logic to find the value for the given date
        // from the sample data
        return 0.0
    }
}

extension AnimatedChartLine: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let minDate = samples.map { $0.date }.min()!
        let maxDate = samples.map { $0.date }.max()!
        let dateRange = minDate.timeIntervalSince1970...maxDate.timeIntervalSince1970
        
        let minValue = samples.map { $0.value }.min() ?? 0
        let maxValue = samples.map { $0.value }.max() ?? 0
        let valueRange = minValue...maxValue
        
        let xAxis = AXNumericDataAxisDescriptor(title: "Date",
                                                range: dateRange,
                                                gridlinePositions: []) { Date(timeIntervalSince1970: $0).formatted(date: .abbreviated, time: .omitted) }
        
        let yAxis = AXNumericDataAxisDescriptor(title: "Value",
                                                range: valueRange,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        
        let series = AXDataSeriesDescriptor(name: "Data",
                                            isContinuous: true, dataPoints: samples.map {
                                                .init(x: $0.date.timeIntervalSince1970, y: $0.value)
                                            })
        
        return AXChartDescriptor(title: "Animated Change in Data",
                                 summary: nil,
                                 xAxis: xAxis,
                                 yAxis: yAxis,
                                 additionalAxes: [],
                                 series: [series])
    }
}
