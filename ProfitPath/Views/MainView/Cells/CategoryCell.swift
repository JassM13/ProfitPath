//
//  CategoryCell.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct CategoryCell: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.2))
                        .colorScheme(.light)
                )
                .cornerRadius(16)
        }
    }
}
