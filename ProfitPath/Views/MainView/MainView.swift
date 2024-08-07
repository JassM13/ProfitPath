//
//  MainView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

import SwiftUI

struct MainView: View {
    @ObservedObject var navigationController = NavigationController.shared
    @StateObject var accountManager = AccountManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image("logo") // Use the correct asset name
                        .resizable()
                        .frame(width: 32, height: 32) // Reduced size
                        .cornerRadius(5)
                    
                    Menu {
                        ForEach(accountManager.accounts) { account in
                            Button(action: {
                                accountManager.selectAccount(account)
                            }) {
                                Text(account.name)
                            }
                        }
                        Button(action: {
                            accountManager.createAccount(name: "New Account \(accountManager.accounts.count + 1)")
                        }) {
                            Text("New Account")
                                .fontWeight(.bold)
                        }
                    } label: {
                        HStack {
                            Text(accountManager.selectedAccount.name)
                                .fontWeight(.medium)
                                .font(.system(size: 16)) // Reduced font size
                                .foregroundColor(.white) // Adjust color as needed
                                .padding(.horizontal, 4) // Reduced padding
                                .background(Color.black.opacity(0.2)) // Slight background for better readability
                            
                            Image(systemName: "chevron.down") // Replace with desired icon
                                .foregroundColor(.white)
                                .imageScale(.small) // Adjust icon size
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "list.dash")
                            .fontWeight(.medium)
                    }
                }
                .padding([.horizontal, .bottom])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                            HStack {
                                Button(action: {
                                    navigationController.updateCurrentView(AnyView(DashboardView()), viewName: "Dashboard")
                                }) {
                                    CategoryCell(text: "Dashboard", isSelected: navigationController.viewName == "Dashboard")
                                }
                                Button(action: {
                                    navigationController.updateCurrentView(AnyView(JournalView()), viewName: "Journal")
                                }) {
                                    CategoryCell(text: "Journal", isSelected: navigationController.viewName == "Journal")
                                }
                                Button(action: {
                                    navigationController.updateCurrentView(AnyView(TradesView()), viewName: "Trades")
                                }) {
                                    CategoryCell(text: "Trades", isSelected: navigationController.viewName == "Trades")
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    
                    if let currentView = navigationController.currentView {
                        currentView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
