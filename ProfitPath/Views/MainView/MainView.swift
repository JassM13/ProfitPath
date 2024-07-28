//
//  MainView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var navigationController = NavigationController.shared
    
    @StateObject var tradeJournal = TradeJournal.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                                    navigationController.updateCurrentView(AnyView(PerformanceView()), viewName: "Performance")
                                }) {
                                    CategoryCell(text: "Performance", isSelected: navigationController.viewName == "Performance")
                                }
                                Button(action: {
                                    navigationController.updateCurrentView(AnyView(JournalView()), viewName: "Journal")
                                }) {
                                    CategoryCell(text: "Journal", isSelected: navigationController.viewName == "Journal")
                                }
                                Button(action: {
                                    navigationController.updateCurrentView(AnyView(ReportsView()), viewName: "Reports")
                                }) {
                                    CategoryCell(text: "Reports", isSelected: navigationController.viewName == "Reports")
                                }
                                Button(action: {
                                    navigationController.updateCurrentView(AnyView(TradesView()), viewName: "Trades")
                                }) {
                                    CategoryCell(text: "Trades", isSelected: navigationController.viewName == "Trades")
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 80)
                    
                    if let currentView = navigationController.currentView {
                        currentView
                    }
                    Spacer()
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Image(.logo)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(5)
                    Text("EXPRESSTST291482")
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                }.padding(.bottom),
                trailing: Button(action: {
                    print("Navigation button tapped")
                }) {
                    Image(.list)
                        .foregroundStyle(.black)
                }.padding(.bottom)
            )
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
