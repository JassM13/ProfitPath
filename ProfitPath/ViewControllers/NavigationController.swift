//
//  NavigationController.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/26/24.
//

import SwiftUI
import Combine

class NavigationController: ObservableObject {
    static let shared = NavigationController()
    @Published var currentView: AnyView? = AnyView(DashboardView())
    @Published var viewName: String? = "Dashboard"
    
    private init() {}
    
    func updateCurrentView(_ view: AnyView?, viewName: String? = nil) {
        currentView = view
        self.viewName = viewName
    }
}
