//
//  CurvedLineChart.swift
//
//
//  Created by Jaspreet Malak on 3/31/24.
//

import SwiftUI

struct CurvedLineChart: View {
    private var data: [ChartData]
    private let frame: CGRect
    private let offset: Double
    
    @StateObject private var detailManager = ChartDetailManager.shared
    
    public init(data: [ChartData],
                frame: CGRect,
                offset: Double = 0) {
        // Sort the data by date and add a zero point at the earliest date
        var sortedData = data.sorted { $0.date < $1.date }
        if let earliestDate = sortedData.first?.date {
            sortedData.insert(ChartData(date: earliestDate, value: 0), at: 0)
        }
        self.data = sortedData
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
                // Only the vertical line is kept here
                Path { path in
                    let touchX = detailManager.touchLocation.x
                    var topY = 20 // Offset from the top for aesthetic purposes
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
            curvedPathGradient()
                .fill(LinearGradient(
                    gradient: .init(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.02)]),
                    startPoint: .init(x: 0.5, y: 1),
                    endPoint: .init(x: 0.5, y: 0)
                ))
            curvedPath()
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
        }
    }
    
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
            let y = height * CGFloat(1 - normalizedValue) // No need to invert Y axis
            return CGPoint(x: x, y: y)
        }
    }
    
    private func curvedPath() -> Path {
        let points = chartDataToPoints()
        func mid(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
            return CGPoint(x: (point1.x + point2.x) / 2, y:(point1.y + point2.y) / 2)
        }
        
        func control(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
            var controlPoint = mid(point1, point2)
            let delta = abs(point2.y - controlPoint.y)
            
            if point1.y < point2.y {
                controlPoint.y += delta
            } else if point1.y > point2.y {
                controlPoint.y -= delta
            }
            
            return controlPoint
        }
        
        var path = Path()
        guard points.count > 1 else { return path }
        
        var startPoint = points[0]
        path.move(to: startPoint)
        
        guard points.count > 2 else {
            path.addLine(to: points[1])
            return path
        }
        
        for i in 1..<points.count {
            let currentPoint = points[i]
            let midPoint = mid(startPoint, currentPoint)
            
            path.addQuadCurve(to: midPoint, control: control(midPoint, startPoint))
            path.addQuadCurve(to: currentPoint, control: control(midPoint, currentPoint))
            
            startPoint = currentPoint
        }
        
        return path
    }
    
    private func curvedPathGradient() -> Path {
        var path = curvedPath()
        guard let lastPoint = chartDataToPoints().last else { return path }
        path.addLine(to: CGPoint(x: lastPoint.x, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: chartDataToPoints().first?.y ?? 0))
        
        return path
    }
}
