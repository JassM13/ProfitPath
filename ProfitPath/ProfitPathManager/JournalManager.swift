//
//  JournalManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/20/24.
//

import SwiftData
import Foundation

@MainActor
class JournalManager: ObservableObject {
    static let shared = JournalManager()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    @Published var accounts: [Account] = []
    @Published var selectedAccount: Account
    
    private init() {
        do {
            container = {
                do {
                    let schema = Schema([Account.self])
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
    
    func loadAccounts() async throws {
        let descriptor = FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)])
        accounts = try context.fetch(descriptor)
        if accounts.isEmpty {
            let defaultAccount = Account(name: "Default Account")
            context.insert(defaultAccount)
            accounts = [defaultAccount]
            selectedAccount = defaultAccount
        } else if !accounts.contains(where: { $0.id == selectedAccount.id }) {
            selectedAccount = accounts[0]
        }
        try context.save()
    }
    
    func createAccount(name: String) {
        let newAccount = Account(name: name)
        context.insert(newAccount)
        accounts.append(newAccount)
        saveContext()
    }
    
    func selectAccount(_ account: Account) {
        guard accounts.contains(where: { $0.id == account.id }) else {
            print("Attempted to select an account that doesn't exist")
            return
        }
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
        let newGroup = TradeGroup(createdAt: Date(), isManuallyGrouped: false)
        newGroup.trades = [trade]
        
        selectedAccount.tradeGroups.append(newGroup)
        
        saveContext()
    }
    
    func deleteTradeGroup(_ tradeGroup: TradeGroup) {
        if let account = tradeGroup.account {
            account.tradeGroups.removeAll(where: { $0.id == tradeGroup.id })
        }
        context.delete(tradeGroup)
        saveContext()
    }
    
    func createManualTradeGroup(trades: [Trade], in account: Account) {
        let newGroup = TradeGroup(createdAt: Date(), isManuallyGrouped: true)
        newGroup.trades = trades
        newGroup.account = account
        
        account.tradeGroups.append(newGroup)
        
        // Remove these trades from their original groups
        for trade in trades {
            if let originalGroup = account.tradeGroups.first(where: { $0.trades.contains(where: { $0.id == trade.id }) }) {
                originalGroup.trades.removeAll(where: { $0.id == trade.id })
                if originalGroup.trades.isEmpty {
                    account.tradeGroups.removeAll(where: { $0.id == originalGroup.id })
                    context.delete(originalGroup)
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
            
            saveContext()
            return deleteAccount()
        }
        
        deleteAccount()
        func deleteAccount() {
            accounts.removeAll(where: { $0.id == account.id })
            context.delete(account)
            
            if selectedAccount.id == account.id {
                selectedAccount = accounts[0]
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
