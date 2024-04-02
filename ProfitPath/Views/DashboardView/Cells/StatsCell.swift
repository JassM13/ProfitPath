//
//  StatusCell.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/28/24.
//

import SwiftUI

struct StatsCell: View {
    var icon: String
    var iconColor: Color
    var title: String
    var value: String

    var body: some View {
        HStack(spacing: 16) {
            Image(icon)
                .font(.system(size: 26))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.2))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.dynamicTypeSize(.xSmall)
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    StatsCell(icon: "graph-up", iconColor: Color.green, title: "Best-Day", value: "$1600")
}
