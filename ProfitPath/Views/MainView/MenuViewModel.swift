//
//  MenuViewModel.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import Foundation
import SwiftUI

class MenuViewModel: ObservableObject {
    
    @Published var selectedCategory: String?
    
    @Published var catergories = ["Dashboard", "Performance", "Journal", "Reports"]
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    
    init() {
        selectedCategory = catergories.first
    }
}
