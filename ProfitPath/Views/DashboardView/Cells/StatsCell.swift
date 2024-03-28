//
//  StatusCell.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/28/24.
//

import SwiftUI

struct StatsCell: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
            Text(value)
                .font(.title3.bold())
        }
        .padding() // Provide padding within the cell
        .background( // Add background
            RoundedRectangle(cornerRadius: 10) // Choose your corner radius
                .fill(Color.gray.opacity(0.2))
        )
    }
}

#Preview {
    StatsCell(title: "Profit", value: "50")
}
