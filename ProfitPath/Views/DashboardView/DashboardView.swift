//
//  DashboardView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var dashboardManager = DashboardManager.shared
    
    @State private var isEditMode = false
    @State private var showingAddItemSheet = false
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(dashboardManager.items.enumerated()), id: \.element.id) { index, item in
                        itemView(for: item)
                            .overlay(editOverlay(for: item, at: index))
                    }
                }
                .padding()
                
                if isEditMode {
                    VStack {
                        HStack {
                            Button(action: { showingAddItemSheet = true }) {
                                Label("Add Widget", systemImage: "plus")
                            }
                            Spacer()
                            Button(action: {
                                isEditMode = false
                                dashboardManager.saveState()
                            }) {
                                Text("Done")
                            }
                        }
                        .padding()
                        .background(.white.opacity(0.025))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
            }
            
            //Spacer()
            
        }
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    withAnimation {
                        isEditMode.toggle()
                    }
                }
        )
        .sheet(isPresented: $showingAddItemSheet) {
            AddItemView(onAdd: { itemType in
                dashboardManager.addNewItem(of: itemType)
                showingAddItemSheet = false
            })
        }
    }
    
    @ViewBuilder
    func itemView(for item: DashboardItem) -> some View {
        switch item.type {
        case .Chart:
            ChartView()
                .disabled(isEditMode)
        case .totalProfit:
            TotalProfitView()
        case .stats:
            StatsView()
        case .profitGoal:
            ProfitGoalView()
        }
    }
    
    func editOverlay(for item: DashboardItem, at index: Int) -> some View {
        VStack {
            if isEditMode {
                HStack(spacing: 15) { // Add spacing between buttons
                    if index > 0 {
                        Button(action: {
                            dashboardManager.moveItem(item, offset: -1)
                        }) {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.white)
                        }
                    }
                    
                    if index < dashboardManager.items.count - 1 {
                        Button(action: {
                            dashboardManager.moveItem(item, offset: 1)
                        }) {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            dashboardManager.removeItem(item)
                        }
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.white)
                    }
                }
                .padding([.all], 15)
                .background(Color.clear) // Slightly more transparent
                .clipShape(RoundedRectangle(cornerRadius: 6)) // Rounded corners
                .shadow(radius: 10) // Subtle shadow for better visibility
                .transition(.scale)
            }
            Spacer()
        }
    }
}

struct AddItemView: View {
    let onAdd: (DashboardItemType) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List(DashboardItemType.allCases, id: \.self) { itemType in
            Button(action: {
                onAdd(itemType)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(itemType.rawValue)
            }
        }
        .navigationTitle("Add Widget")
    }
}
