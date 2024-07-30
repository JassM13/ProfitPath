//
//  MainView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct PickerOption: Identifiable, Hashable {
    let id = UUID()
    let title: String
}


let pickerOptions = [
    PickerOption(title: "EXPRESSTST291482"),
    PickerOption(title: "EXPRESSTST123456"),
    PickerOption(title: "EXPRESSTST789012")
]


struct MainView: View {
    @State private var selectedOption: PickerOption = pickerOptions[0]
    
    @ObservedObject var navigationController = NavigationController.shared
    
    @StateObject var tradeJournal = TradeJournal.shared
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("logo") // Use the correct asset name
                    .resizable()
                    .frame(width: 32, height: 32) // Reduced size
                    .cornerRadius(5)
                
                Menu {
                    ForEach(pickerOptions) { option in
                        Button(action: {
                            selectedOption = option
                        }) {
                            Text(option.title)
                        }
                    }
                } label: {
                    Text(selectedOption.title)
                        .fontWeight(.medium)
                        .font(.system(size: 16)) // Reduced font size
                        .foregroundColor(.white) // Adjust color as needed
                        .padding(.horizontal, 4) // Reduced padding
                        .background(Color.black.opacity(0.2)) // Slight background for better readability
                    
                    Image(systemName: "chevron.down") // Replace with desired icon
                        .foregroundColor(.white)
                        .imageScale(.small) // Adjust icon size
                }
                
                Spacer()
                
                Image(systemName: "list.dash")
                    .fontWeight(.medium)
                
            }
            .padding([.horizontal, .bottom]) // Adjusted horizontal padding to match new size

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
                    .padding([.horizontal, .bottom])
                }
                //.frame(height: 80)
                
                if let currentView = navigationController.currentView {
                    currentView
                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
