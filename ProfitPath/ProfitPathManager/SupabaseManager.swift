//
//  SupabaseManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import Foundation
import Supabase

@MainActor
class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    private let supabase: SupabaseClient
    
    @Published var currentUser: Auth.User?
    
    private init() {
        supabase = SupabaseClient(
            supabaseURL: URL(string: "https://msofwvochjiraefqfpie.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zb2Z3dm9jaGppcmFlZnFmcGllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQzNTA0MzAsImV4cCI6MjAzOTkyNjQzMH0.SUjPcR8LivLMVoaHVW-FdspWeuniuQdEQFLHpgHmEes"
          )
        
        // Check for existing session
        Task {
            await getCurrentUser()
        }
    }
    
    func getCurrentUser() async {
        do {
            let session = try await supabase.auth.session
            self.currentUser = session.user
        } catch {
            print("Error getting current user: \(error)")
            self.currentUser = nil
        }
    }
    
    func signUp(email: String, password: String) async throws -> Auth.User {
        let authResponse = try await supabase.auth.signUp(email: email, password: password)
        // No need to unwrap, directly use the user
        let user = authResponse.user
        await getCurrentUser()
        return user
    }

    func signIn(email: String, password: String) async throws -> Auth.User {
        let authResponse = try await supabase.auth.signIn(email: email, password: password)
        // No need to unwrap, directly use the user
        let user = authResponse.user
        await getCurrentUser()
        return user
    }

    
    func signOut() async throws {
        try await supabase.auth.signOut()
        await getCurrentUser()
    }
    
    // Add more Supabase-related methods here as needed
    // For example: CRUD operations, real-time subscriptions, etc.
}
