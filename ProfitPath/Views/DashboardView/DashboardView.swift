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
                        .fill(Color.white.opacity(0.05))
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

            HStack {
                Text("Total Profit")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("$13,000")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.025))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            )
            
            ZStack() {
                    HStack {
                        VStack(alignment: .leading) {
                            StatsCell(icon: "graph-up", iconColor: Color.green, title: "Best Day", value: String(format: "$1600"))
                            StatsCell(icon: "winrate", iconColor: Color.green, title: "WinRate", value: String(format: "80%%"))
                                .padding(.top, 5)
                        }
                        Spacer()

                        VStack(alignment: .leading) {
                            StatsCell(icon: "graph-down", iconColor: Color.red, title: "Worst Day", value: String(format: "-$260"))
                            StatsCell(icon: "R:R", iconColor: Color.red, title: "R:R", value: String(format: "2.2"))
                                .padding(.top, 5)
                        }
                    }
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.025)))
                    Spacer()
            }
            
            ZStack {
                ProgressView(value: 1850, total: 3000, label: {
                    Text("Profit Goal")
                        .font(.headline)
                        .foregroundColor(.white)
                }, currentValueLabel: {
                    Text("1850/3000")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                })
                .padding(.all)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.025))
                )
            }
        }
        .padding([.horizontal])
        Spacer()
    }
}

#Preview {
    DashboardView()
}
