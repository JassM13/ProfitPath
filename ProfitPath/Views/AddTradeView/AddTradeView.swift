//
//  AddTradeView.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/15/24.
//

import SwiftUI

struct AddTradeView: View {
    @StateObject private var accountManager = AccountManager.shared
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var trade = Trade(
        id: UUID(),
        contractName: "",
        enteredAt: Date(),
        exitedAt: Date(),
        entryPrice: 0.0,
        exitPrice: 0.0, 
        fees: 0.0,
        pnl: 0.0,
        size: 1,
        type: "Long",
        instrumentType: "Futures",
        tradeDay: Date()
    )
    
    let tradeTypes = ["Long", "Short"]
    let instrumentTypes = ["Futures", "Forex", "Stocks"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trade Details")) {
                    TextField("Contract Name", text: Binding(
                        get: { trade.contractName.uppercased() },
                        set: { trade.contractName = $0.uppercased() }
                    ))
                    Picker("Type", selection: $trade.type) {
                        ForEach(tradeTypes, id: \.self) { Text($0) }
                    }
                    .onChange(of: trade.type) { updateCalculatedProfit() }
                    Picker("Instrument", selection: $trade.instrumentType) {
                        ForEach(instrumentTypes, id: \.self) { Text($0) }
                    }
                    DatePicker("Entered At", selection: $trade.enteredAt, displayedComponents: [.date, .hourAndMinute])
                                            .onChange(of: trade.enteredAt) {
                                                trade.tradeDay = trade.enteredAt
                                            }
                    DatePicker("Exited At", selection: $trade.exitedAt, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Price Information")) {
                    HStack {
                        Text("Entry Price")
                        Spacer()
                        TextField("0.0", value: $trade.entryPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: trade.entryPrice) { updateCalculatedProfit() }
                    }
                    HStack {
                        Text("Exit Price")
                        Spacer()
                        TextField("0.0", value: $trade.exitPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: trade.exitPrice) { updateCalculatedProfit() }
                    }
                    HStack {
                        Text("Size")
                        Spacer()
                        TextField("0.0", value: $trade.size, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: trade.size) { updateCalculatedProfit() }
                    }
                }
                
                Section(header: Text("Profit Information")) {
                            HStack {
                                Text("Profit")
                                Spacer()
                                TextField("0.0", value: $trade.pnl, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                
                Section(header: Text("Additional Information")) {
                    HStack {
                        Text("Fees")
                        Spacer()
                        TextField("0.0", value: $trade.fees, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: trade.fees) { updateCalculatedProfit() }
                    }
                }
            }
            .navigationTitle("Add New Trade")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save")
                    {
                        accountManager.addTrade(trade)
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func updateCalculatedProfit() {
        trade.pnl = calculatePNL()
    }
    
    private func calculatePNL() -> Double {
        let contractMultiplier: Double
        switch trade.instrumentType {
        case "Futures":
            switch trade.contractName.lowercased() {
            case "nq":
                contractMultiplier = 20
            case "es":
                contractMultiplier = 50
            default:
                contractMultiplier = 1
            }
        case "Forex":
            contractMultiplier = 100000 // Assuming standard lot size
        case "Stocks":
            contractMultiplier = 1
        default:
            contractMultiplier = 1
        }
        
        let rawPNL = (trade.exitPrice - trade.entryPrice) * trade.size * contractMultiplier
        let grossPNL = trade.type == "Long" ? rawPNL : -rawPNL
        return grossPNL - trade.fees
    }
}

#Preview {
    AddTradeView()
}
