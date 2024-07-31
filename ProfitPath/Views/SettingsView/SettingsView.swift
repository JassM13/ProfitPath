//
//  SettingsView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @StateObject private var accountManager = AccountManager.shared
    @State private var showingAddAccount = false
    @State private var newAccountName = ""
    @State private var accountToDelete: Account?
    @State private var showingDeleteWarning = false
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(header: Text("Accounts")) {
                    ForEach(accountManager.accounts) { account in
                        AccountRow(account: account)
                    }
                    .onDelete(perform: deleteAccount)
                }
                
                Section {
                    Button(action: { showingAddAccount = true }) {
                        Label("Add New Account", systemImage: "plus.circle")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView(isPresented: $showingAddAccount, accountName: $newAccountName)
            }
            .alert(isPresented: $showingDeleteWarning) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete this account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let account = accountToDelete {
                            accountManager.deleteAccount(account)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func deleteAccount(at offsets: IndexSet) {
        if let index = offsets.first, accountManager.accounts.count > 1 {
            accountToDelete = accountManager.accounts[index]
            showingDeleteWarning = true
        }
    }
}

struct AccountRow: View {
    let account: Account
    @StateObject private var accountManager = AccountManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(account.name)
                    .font(.headline)
                Text("Trades: \(account.trades.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if account.id == accountManager.selectedAccount.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            accountManager.selectAccount(account)
        }
    }
}

struct AddAccountView: View {
    @Binding var isPresented: Bool
    @Binding var accountName: String
    @StateObject private var accountManager = AccountManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Account Name", text: $accountName)
                }
                
                Section {
                    Button("Create Account") {
                        if !accountName.isEmpty {
                            accountManager.createAccount(name: accountName)
                            isPresented = false
                            accountName = ""
                        }
                    }
                }
            }
            .navigationTitle("New Account")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

#Preview {
    SettingsView()
}
