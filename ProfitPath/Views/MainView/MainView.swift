//
//  MainView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var navigationController = NavigationController.shared
    @StateObject var journalManager = JournalManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image("logo") // Use the correct asset name
                        .resizable()
                        .frame(width: 32, height: 32) // Reduced size
                        .cornerRadius(5)
                    
                    Menu {
                        ForEach(journalManager.accounts) { account in
                            Button(action: {
                                journalManager.selectAccount(account)
                            }) {
                                Text(account.name)
                            }
                        }
                        Button(action: {
                            journalManager.createAccount(name: "New Account \(journalManager.accounts.count + 1)")
                        }) {
                            Text("New Account")
                                .fontWeight(.bold)
                        }
                    } label: {
                        HStack {
                            Text(journalManager.selectedAccount.name)
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
                                    navigationController.updateCurrentView(AnyView(CalendarView()), viewName: "Calendar")
                                }) {
                                    CategoryCell(text: "Calendar", isSelected: navigationController.viewName == "Calendar")
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
