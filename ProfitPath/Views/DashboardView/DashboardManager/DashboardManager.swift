//
//  DashboardManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/19/24.
//

import Foundation
import SwiftUI

class DashboardManager: ObservableObject {
    static let shared = DashboardManager()
    
    @Published var items: [DashboardItem] = []
    
    private init() {
        loadState()
    }
    
    func addNewItem(of type: DashboardItemType) {
        let newItem = DashboardItem(type: type)
        items.append(newItem)
        saveState()
    }
    
    func removeItem(_ item: DashboardItem) {
        items.removeAll { $0.id == item.id }
        saveState()
    }
    
    func moveItem(_ item: DashboardItem, offset: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let newIndex = index + offset
        
        // Check if new index is valid
        if newIndex >= 0 && newIndex < items.count {
            withAnimation {
                // Remove item from the current index
                let itemToMove = items.remove(at: index)
                // Insert item at the new index
                items.insert(itemToMove, at: newIndex)
            }
        }
    }
    
    func saveState() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: "dashboardItems")
        }
    }
    
    func loadState() {
        if let savedItems = UserDefaults.standard.data(forKey: "dashboardItems") {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([DashboardItem].self, from: savedItems) {
                items = loadedItems
            }
        } else {
            // Initialize with default items if no saved state
            items = [
                DashboardItem(type: .Chart),
                DashboardItem(type: .totalProfit),
                DashboardItem(type: .stats),
                DashboardItem(type: .profitGoal)
            ]
        }
    }
}
