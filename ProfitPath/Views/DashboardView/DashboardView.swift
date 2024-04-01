//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import Spectra

struct DashboardView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            SpectraView(data: [2, 17, 9, 23, 10],
                                        type: .curved,
                                        visualType: .filled(color: .green, lineWidth: 3),
                                        offset: 0.2,
                                        currentValueLineType: .dash(color: .gray, lineWidth: 1, dash: [5])
                            )
                            .padding(.top)
                            .mask(
                                RoundedRectangle(cornerRadius: 8)
                            )
                        )
            }
            .frame(height: UIScreen.main.bounds.height / 3.8)

            HStack(alignment: .top) {
                StatsCell(icon: "chart.line.uptrend.xyaxis", iconColor: Color.green, title: "Best-Day ", value: String(format: "$1600"))
                Spacer()
                StatsCell(icon: "chart.line.downtrend.xyaxis", iconColor: Color.red, title: "Worst-Day", value: String(format: "$260"))

                Spacer()
            }
        }
        .padding([.horizontal])
        Spacer()
    }
}

#Preview {
    DashboardView()
}
