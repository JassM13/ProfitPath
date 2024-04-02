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
                        .fill(Color.white.opacity(0.02))
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

            ZStack() {
                    HStack {
                        VStack(alignment: .leading) {
                            StatsCell(icon: "graph-up", iconColor: Color.green, title: "Best Day", value: String(format: "$1600"))
                            StatsCell(icon: "winrate", iconColor: Color.green, title: "WinRate", value: String(format: "80%%"))
                                .padding(.top, 5)
                        }
                        Spacer()

                        VStack(alignment: .leading) {
                            StatsCell(icon: "graph-down", iconColor: Color.red, title: "Worst Day", value: String(format: "$260"))
                            StatsCell(icon: "R:R", iconColor: Color.red, title: "R:R", value: String(format: "2.2"))
                                .padding(.top, 5)
                        }
                    }
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.01)))
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
