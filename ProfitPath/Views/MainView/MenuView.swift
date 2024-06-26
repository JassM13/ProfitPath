//
//  MenuView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MenuViewModel
    
    var body: some View {
        NavigationView {
            NavigationStack(path: $viewModel.navigationPath) {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                                ForEach(viewModel.catergories, id: \.self) { item in
                                    NavigationLink(value: item) {
                                        CategoryCell(text: item, isSelected: viewModel.selectedCategory == item) {
                                            viewModel.selectedCategory = item
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(height: 80)
                        
                        Group {
                            if let category = viewModel.selectedCategory {
                                contentView(for: category)
                            } else {
                                Text("Select a Category")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
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
                            },
                            trailing: Button(action: {
                                print("Navigation button tapped")
                            }) {
                                Image(.list)
                            }
                        )
                }
        .navigationBarBackButtonHidden(true)
    }
}

@ViewBuilder
func contentView(for category: String?) -> some View {
    switch category {
    case "Dashboard":
        DashboardView()
    case "Performance":
        PerformanceView()
    case "Journal":
        JournalView().background(Color.yellow)
    case "Reports":
        ReportsView().background(Color.orange)
    default:
        Text("Select a Category").background(Color.gray)
    }
}

#Preview {
    MainView(viewModel: MenuViewModel())
    /*NavigationView {
        MainView(viewModel: MenuViewModel())
    }*/
}
