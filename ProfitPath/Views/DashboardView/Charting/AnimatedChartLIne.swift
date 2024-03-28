//
//  AnimatedChartLIne.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/28/24.
//

import SwiftUI
import Charts

struct AnimatedChartLine: View, Animatable {
    var animatableData: Double

    init(x: Double) {
        self.animatableData = x
    }

    let samples = stride(from: -1, through: 1, by: 0.01).map {
        Sample(x: $0, y: pow($0, 3))
    }

    var body: some View {
        Chart {
            ForEach(samples) { sample in
                LineMark(
                    x: .value("x", sample.x),
                    y: .value("y", sample.y)
                )
                .accessibilityLabel("\(sample.x)")
                .accessibilityValue("\(sample.y)")
            }

            PointMark(
                x: .value("x", animatableData),
                y: .value("y", pow(animatableData, 3))
            )
        }
        .accessibilityChartDescriptor(self)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }

    struct Sample: Identifiable {
        var x: Double
        var y: Double
        var id: some Hashable { x }
    }
}

extension AnimatedChartLine: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXNumericDataAxisDescriptor(title: "Position",
                                                range: 1...1,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        let yAxis = AXNumericDataAxisDescriptor(title: "Value",
                                                range: -1...1,
                                                gridlinePositions: []) { String(format: "%.2f", $0) }
        let series = AXDataSeriesDescriptor(name: "Data",
                                            isContinuous: true, dataPoints: samples.map {
            .init(x: $0.x, y: $0.y)
        })

        return AXChartDescriptor(title: "Animated Change in Data",
                                 summary: nil,
                                 xAxis: xAxis,
                                 yAxis: yAxis,
                                 additionalAxes: [],
                                 series: [series])
    }
}
