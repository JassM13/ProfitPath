//
//  File.swift
//  
//
//  Created by Jaspreet Malak on 3/31/24.
//

/*
import SwiftUI

public struct LineChart: View {
    private let data: [ChartData]
    private let frame: CGRect
    private let offset: Double
    private let type: ChartVisualType
    private let currentValueLineType: CurrentValueLineType
    
    /// Creates a new `LineChart`
    ///
    /// - Parameters:
    ///     - data: A data set that should be presented on the chart
    ///     - frame: A frame from the parent view
    ///     - visualType: A type of chart, `.outline` by default
    ///     - offset: An offset for the chart, a space below the chart in percentage (0 - 1)
    ///               For example `offset: 0.2` means that the chart will occupy 80% of the upper
    ///               part of the view
    ///     - currentValueLineType: A type of current value line (`none` for no line on chart)
    public init(data: [ChartData],
                frame: CGRect,
                visualType: ChartVisualType = .outline(color: .red, lineWidth: 2),
                offset: Double = 0,
                currentValueLineType: CurrentValueLineType = .none) {
        self.data = data
        self.frame = frame
        self.type = visualType
        self.offset = offset
        self.currentValueLineType = currentValueLineType
    }
    
    public var body: some View {
        ZStack {
            chart
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
            line
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
    
    private var chart: some View {
        switch type {
            case .outline(let color, let lineWidth):
                return AnyView(linePath()
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round)))
            case .filled(let color, let lineWidth):
                return AnyView(ZStack {
                    linePathGradient()
                        .fill(LinearGradient(
                            gradient: .init(colors: [color.opacity(0.2), color.opacity(0.02)]),
                            startPoint: .init(x: 0.5, y: 1),
                            endPoint: .init(x: 0.5, y: 0)
                        ))
                    linePath()
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
                })
            case .customFilled(let color, let lineWidth, let fillGradient):
                return AnyView(ZStack {
                    linePathGradient()
                        .fill(fillGradient)
                    linePath()
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
                })
        }
    }
    
    private var line: some View {
        switch currentValueLineType {
            case .none:
                return AnyView(EmptyView())
            case .line(let color, let lineWidth):
                return AnyView(
                    currentValueLinePath()
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth))
                )
            case .dash(let color, let lineWidth, let dash):
                return AnyView(
                    currentValueLinePath()
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, dash: dash))
                )
        }
    }

    // MARK: private functions
    
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
        path.addLine(to: CGPoint(x: lastPoint.x, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: points[0].y))
        
        return path
    }
    
    private func currentValueLinePath() -> Path {
        let points = chartDataToPoints()
        var path = Path()
        guard let lastPoint = points.last else {
            return path
        }
        path.move(to: CGPoint(x: 0, y: lastPoint.y))
        path.addLine(to: lastPoint)
        return path
    }
}

extension LineChart: DataRepresentable { }
*/
