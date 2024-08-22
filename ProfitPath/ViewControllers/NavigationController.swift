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
    
    // Animation properties
    @Published var isAnimating: Bool = false
    private var currentAnimation: Animation = .default
    private var currentTransition: AnyTransition = .opacity
    
    private init() {}
    
    func updateCurrentView(
        _ view: AnyView?,
        viewName: String? = nil,
        animation: Animation = .default,
        transition: AnyTransition = .opacity
    ) {
        self.currentAnimation = animation
        self.currentTransition = transition
        
        withAnimation(self.currentAnimation) {
            self.isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Small delay to ensure animation starts
            withAnimation(self.currentAnimation) {
                self.currentView = view
                self.viewName = viewName
                self.isAnimating = false
            }
        }
    }
}
