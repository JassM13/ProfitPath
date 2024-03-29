//
//  PerformanceView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import SwiftUICharts

struct PerformanceView: View {
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    var body: some View {
        VStack {
            ZStack {
                BarChart()
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                               foregroundColor: ColorGradient(.yellow, .yellow)))
                    .padding([.top, .horizontal])
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(width: UIScreen.main.bounds.height / 2.6)
                    
            }
            .frame(height: UIScreen.main.bounds.height / 3.8)
        }
        Spacer()
    }
}

#Preview {
    PerformanceView()
}
