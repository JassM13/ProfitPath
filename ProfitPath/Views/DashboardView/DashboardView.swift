//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @State private var x: Double = -0.6

    var body: some View {
        VStack {
            ZStack {
                AnimatedChartLine(x: x)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16)
                    )
            }
            .frame(height: UIScreen.main.bounds.height / 3.8)

            HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                StatsCell(title: "Profit %", value: String(format: "%.1f%%"))
                                StatsCell(title: "Risk to Reward", value: String(format: "%.1f"))
                                Spacer()
                            }
                            //.padding(.top)

                            Spacer()
            }
        }.padding([.horizontal, .bottom])
    }
}

#Preview {
    DashboardView()
}
