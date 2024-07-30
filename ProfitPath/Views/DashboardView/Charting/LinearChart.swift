//
//  LinearChart.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/30/24.
//

import SwiftUI

struct LineChartView: View {
    let trades: [Trade]
    
    private func getPath(for trades: [Trade], in size: CGSize) -> Path {
        var path = Path()
        guard let firstTrade = trades.first else { return path }
        
        let width = size.width
        let height = size.height
        
        let maxValue = trades.max(by: { $0.pnl < $1.pnl })?.pnl ?? 1
        let minValue = trades.min(by: { $0.pnl < $1.pnl })?.pnl ?? 0
        
        let xScale = width / CGFloat(trades.count - 1)
        let yScale = height / CGFloat(maxValue - minValue)
        
        let startX = CGFloat(trades.firstIndex(of: firstTrade) ?? 0) * xScale
        let startY = height - CGFloat((firstTrade.pnl - minValue) * yScale)
        
        path.move(to: CGPoint(x: startX, y: startY))
        
        for (index, trade) in trades.enumerated() {
            let x = CGFloat(index) * xScale
            let y = height - CGFloat((trade.pnl - minValue) * yScale)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                getPath(for: trades, in: geometry.size)
                    .stroke(Color.accentColor, lineWidth: 2)
                    .background(getPath(for: trades, in: geometry.size).fill(Color.accentColor.opacity(0.2)))
                
                ForEach(0..<trades.count, id: \.self) { index in
                    let trade = trades[index]
                    let x = CGFloat(index) * (geometry.size.width / CGFloat(trades.count - 1))
                    let y = geometry.size.height - CGFloat((trade.pnl - (trades.min(by: { $0.pnl < $1.pnl })?.pnl ?? 0)) * (geometry.size.height / CGFloat((trades.max(by: { $0.pnl < $1.pnl })?.pnl ?? 1) - (trades.min(by: { $0.pnl < $1.pnl })?.pnl ?? 0))))
                    
                    Circle()
                        .fill(.mainColors)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                        .gesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    print("Trade P&L: \(trade.pnl) on \(trade.tradeDay)")
                                }
                        )
                }
            }
        }
        .frame(height: 200)
    }
}
