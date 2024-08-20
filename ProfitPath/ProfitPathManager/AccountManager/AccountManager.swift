//
//  AccountManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import SwiftData
import Foundation

@MainActor
class AccountManager: ObservableObject {
    static let shared = AccountManager()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    @Published var accounts: [Account] = []
    @Published var selectedAccount: Account
    
    private init() {
        do {
            container = {
                do {
                    let schema = Schema([Account.self, TradeGroup.self, Trade.self, LinkedBrokerAccount.self, Journal.self])
                    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                    return try ModelContainer(for: schema, configurations: configuration)
                } catch {
                    fatalError("Error Setting Up Container")
                }
            }()
            context = ModelContext(container)
            
            // Initialize accounts and selectedAccount
            let fetchedAccounts = try context.fetch(FetchDescriptor<Account>(sortBy: [SortDescriptor(\.id)]))
            if fetchedAccounts.isEmpty {
                let defaultAccount = Account(name: "Default Account")
                context.insert(defaultAccount)
                accounts = [defaultAccount]
                selectedAccount = defaultAccount
            } else {
                accounts = fetchedAccounts
                selectedAccount = fetchedAccounts[0]
            }
            
        } catch {
            fatalError("Failed to initialize AccountManager: \(error.localizedDescription)")
        }
    }
    
    
    func loadAccounts() async {
        let descriptor = FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)])
        do {
            accounts = try context.fetch(descriptor)
            if accounts.isEmpty {
                let defaultAccount = Account(name: "Default Account")
                context.insert(defaultAccount)
                accounts = [defaultAccount]
            }
            selectedAccount = accounts.first!
            try context.save()
        } catch {
            print("Failed to fetch accounts: \(error.localizedDescription)")
        }
    }
    
    func createAccount(name: String) {
        let newAccount = Account(name: name)
        context.insert(newAccount)
        accounts.append(newAccount)
        saveContext()
    }
    
    func selectAccount(_ account: Account) {
        selectedAccount = account
    }
    
    func importTrades(from fileURL: URL) {
        if let parsedTrades = CSVParser.parse(fileURL: fileURL) {
            for trade in parsedTrades {
                addTrade(trade)
            }
        }
    }
    
    func addTrade(_ trade: Trade) {
        let newGroup = TradeGroup(trades: [trade])
        selectedAccount.tradeGroups.append(newGroup)
        saveContext()
    }
    
    func deleteTradeGroup(_ tradeGroup: TradeGroup) {
        context.delete(tradeGroup)
        saveContext()
    }
    
    func createManualTradeGroup(trades: [Trade]) {
        let newGroup = TradeGroup(trades: trades, isManuallyGrouped: true)
        selectedAccount.tradeGroups.append(newGroup)
        
        // Remove these trades from their original groups
        for trade in trades {
            if let originalGroup = selectedAccount.tradeGroups.first(where: { $0.trades.contains(where: { $0.id == trade.id }) }) {
                originalGroup.trades.removeAll(where: { $0.id == trade.id })
                if originalGroup.trades.isEmpty {
                    selectedAccount.tradeGroups.removeAll(where: { $0.id == originalGroup.id })
                }
            }
        }
        
        saveContext()
    }
    
    func addJournalEntryToTradeGroup(group: TradeGroup, content: Data) {
        let newEntry = JournalEntry(content: content)
        group.journalEntry = newEntry
        saveContext()
    }
    
    func deleteAccount(_ account: Account) {
        guard accounts.count > 1 else {
            print("Cannot delete the last account.")
            createAccount(name: "Default Account")
            return deleteAccount()
        }
        
        deleteAccount()
        func deleteAccount() {
            context.delete(account)
            if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                accounts.remove(at: index)
            }
            if selectedAccount.id == account.id {
                selectedAccount = accounts.first!
            }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
