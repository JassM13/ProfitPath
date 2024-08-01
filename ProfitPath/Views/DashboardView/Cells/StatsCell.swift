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
    var isSystemIcon: Bool = false // Flag to determine if the icon is a system icon

    var body: some View {
        HStack(spacing: 16) {
            if isSystemIcon {
                // Use system icon
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(iconColor)
                    .frame(width: 40, height: 40)
                    .background(iconColor.opacity(0.2))
                    .cornerRadius(6)
            } else {
                // Use custom icon
                Image(icon)
                    .font(.system(size: 26))
                    .foregroundColor(iconColor)
                    .frame(width: 40, height: 40)
                    .background(iconColor.opacity(0.2))
                    .cornerRadius(6)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .dynamicTypeSize(.xSmall)
        }
    }
}

#Preview {
    VStack {
        StatsCell(icon: "graph-up", iconColor: Color.green, title: "Best Day", value: "$1600")
        StatsCell(icon: "star.fill", iconColor: Color.blue, title: "System Icon", value: "$500", isSystemIcon: true)
    }
}
