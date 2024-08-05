//
//  LineChart.swift
//  
//
//  Created by Jaspreet Malak on 3/31/24.
//

import SwiftUI

struct LineChart: View {
    private let data: [ChartData]
    private let frame: CGRect
    private let offset: Double

    @StateObject private var detailManager = ChartDetailManager.shared
    
    init(data: [ChartData],
                frame: CGRect,
                offset: Double = 0) {
        self.data = data
        self.frame = frame
        self.offset = offset
    }

    public var body: some View {
        ZStack {
            chart
                .drawingGroup()
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            self.updateTouch(value.location)
                        }
                        .onEnded { _ in
                            self.clearTouch()
                        }
                )

            if detailManager.isTouching {
                Path { path in
                    let touchX = detailManager.touchLocation.x
                    let bottomY = frame.height // Extend to the bottom of the frame
                    path.move(to: CGPoint(x: touchX, y: 8))
                    path.addLine(to: CGPoint(x: touchX, y: bottomY - 8))
                }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            }
        }
    }

    private var chart: some View {
        ZStack {
            linePathGradient()
                .fill(LinearGradient(
                    gradient: .init(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.02)]),
                    startPoint: .bottom,
                    endPoint: .top
                ))
            linePath()
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        }
    }

    // MARK: private functions

    private func updateTouch(_ location: CGPoint) {
        let closestPointIndex = chartDataToPoints().enumerated().min(by: { abs($0.1.x - location.x) < abs($1.1.x - location.x) })?.0
        let closestData = closestPointIndex.map { data[$0] }

        if let closestData = closestData {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let formattedDate = dateFormatter.string(from: closestData.date)

            detailManager.isTouching = true
            detailManager.touchLocation = location
            detailManager.detailText = "Date: \(formattedDate)\nPnL: \(closestData.value)"
        }
    }

    private func clearTouch() {
        detailManager.isTouching = false
        detailManager.detailText = ""
    }

    private func chartDataToPoints() -> [CGPoint] {
        let width = frame.width
        let height = frame.height
        let minValue = data.map { $0.value }.min() ?? 0
        let maxValue = data.map { $0.value }.max() ?? 1

        return data.enumerated().map { index, chartData in
            let x = CGFloat(index) / CGFloat(data.count - 1) * width
            let normalizedValue = (chartData.value - minValue) / (maxValue - minValue)
            let y = height * CGFloat(1 - normalizedValue) // Invert Y axis
            return CGPoint(x: x, y: y)
        }
    }

    private func linePath() -> Path {
        let points = chartDataToPoints()
        var path = Path()
        guard points.count > 1 else {
            return path
        }
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        return path
    }

    private func linePathGradient() -> Path {
        let points = chartDataToPoints()
        var path = linePath()
        guard let lastPoint = points.last else {
            return path
        }
        path.addLine(to: CGPoint(x: lastPoint.x, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: points[0].y))

        return path
    }
}
