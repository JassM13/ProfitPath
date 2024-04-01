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
                SpectraView(data: [2, 17, 9, 23, 10],
                            type: .curved,
                            visualType: .filled(color: .green, lineWidth: 3),
                            offset: 0.2,
                            currentValueLineType: .dash(color: .gray, lineWidth: 1, dash: [5])
                )
                .padding(.top)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                )
            }
            .frame(height: UIScreen.main.bounds.height / 3.8)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    StatsCell(title: "Win-Rate %", value: String(format: "60%%"))
                    StatsCell(title: "Risk to Reward", value: String(format: "%.1f"))

                }
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
