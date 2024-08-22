//
//  SignUpView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingSignIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: signUp) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(
                        destination: LoginView().environmentObject(supabaseManager),
                        isActive: $isShowingSignIn
                    ) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        withAnimation {
                            isShowingSignIn = true
                        }
                    }) {
                        Text("Already have an account? Sign In")
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
    
    func signUp() {
        Task {
            do {
                let user = try await supabaseManager.signUp(email: email, password: password)
                alertMessage = "Sign up successful! Please check your email to confirm your account."
                showAlert = true
            } catch {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

#Preview {
    SignUpView()
}
