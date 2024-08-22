//
//  LoginView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingSignUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: signIn) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(
                        destination: SignUpView().environmentObject(supabaseManager),
                        isActive: $isShowingSignUp
                    ) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        withAnimation {
                            isShowingSignUp = true
                        }
                    }) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .transition(.fade)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                let user = try await supabaseManager.signIn(email: email, password: password)
                alertMessage = "Sign in successful!"
                showAlert = true
                // Here you would typically navigate to the main app view
            } catch {
                alertMessage = "Sign in failed: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
