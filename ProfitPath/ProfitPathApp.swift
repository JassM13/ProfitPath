//
//  ProfitPathApp.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

@main
struct ProfitPathApp: App {
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    var body: some Scene {
        WindowGroup {
            if let _ = supabaseManager.currentUser {
                MainView() // User is logged in
            } else {
                OnboardingView() // User is not logged in
            }
        }
    }
}
