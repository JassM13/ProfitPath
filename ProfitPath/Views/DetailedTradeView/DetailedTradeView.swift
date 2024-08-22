//
//  DetailedTradeView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/21/24.
//

import SwiftUI
import Combine

struct DetailedTradeView: View {
    @ObservedObject var navigationController = NavigationController.shared
    @State var tradeGroup: TradeGroup
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TradeSummaryView(tradeGroup: tradeGroup)
            
            Divider()
            
            JournalEntryView(tradeGroup: $tradeGroup)
        }
        .padding(.horizontal)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        navigationController.updateCurrentView(AnyView(TradesView()), viewName: "Trades")
                    }
                }
        )
    }
}
