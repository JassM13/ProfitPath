//
//  DashboardModels.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/19/24.
//

import SwiftUI

struct DashboardItem: Identifiable, Equatable, Codable {
    let id: UUID
    var type: DashboardItemType
    
    init(id: UUID = UUID(), type: DashboardItemType) {
        self.id = id
        self.type = type
    }
    
    static func == (lhs: DashboardItem, rhs: DashboardItem) -> Bool {
        lhs.id == rhs.id
    }
    
}

enum DashboardItemType: String, CaseIterable, Codable {
    case Chart = "Profit Chart"
    case totalProfit = "Total Profit"
    case stats = "Stats"
    case profitGoal = "Profit Goal"
}
