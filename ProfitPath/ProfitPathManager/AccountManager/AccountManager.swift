//
//  AccountManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import SwiftData
import Foundation

class AccountManager: ObservableObject {
    static let shared = AccountManager()
    
    private let modelContainer: ModelContainer
    private let context: ModelContext
    private let journalManager: JournalManager = JournalManager()
    
    @Published private(set) var accounts: [Account]
    @Published private(set) var selectedAccount: Account
    
    private init() {
        do {
            let schema = Schema([
                Account.self,
                Trade.self,
                LinkedBrokerAccount.self,
                Journal.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            context = ModelContext(modelContainer)
            
            // Initialize accounts and selectedAccount
            let fetchedAccounts = try context.fetch(FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)]))
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
    
    func createAccount(name: String) -> Void {
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
        selectedAccount.trades.append(trade)
        saveContext()
    }
    
    func deleteTrade(_ trade: Trade) {
        if let index = selectedAccount.trades.firstIndex(where: { $0.id == trade.id }) {
            selectedAccount.trades.remove(at: index)
            context.delete(trade)
            saveContext()
        }
    }
    
    func linkBrokerAccount(_ brokerAccount: LinkedBrokerAccount) {
        selectedAccount.linkedBrokerAccount = brokerAccount
        saveContext()
    }
    
    func unlinkBrokerAccount() {
        selectedAccount.linkedBrokerAccount = nil
        saveContext()
    }
    
    func getTrades() -> [TradeGroup] {
        let trades = selectedAccount.trades
        return journalManager.smartTradeGrouper.groupTrades(trades)
    }
    
    func deleteAccount(_ account: Account) {
        guard accounts.count > 1 else {
            print("Cannot delete the last account. Creating a new account instead.")
            createAccount(name: "Default Account")
            return deleteAccount()
        }
        
        deleteAccount()
        
        func deleteAccount() {
            if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                accounts.remove(at: index)
                context.delete(account)
                if selectedAccount.id == account.id {
                    selectedAccount = accounts[0]
                }
                saveContext()
            }
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func ensureAccountExists() {
        if accounts.isEmpty {
            createAccount(name: "Default Account")
        }
    }
    
    func updateTradeJournal(for tradeGroup: TradeGroup, notes: String, images: [Data]) {
        tradeGroup.journal.notes = notes
        tradeGroup.journal.images = images
        saveContext()
    }
}
