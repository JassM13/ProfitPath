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
    
    
    private let journalManager: JournalManager = JournalManager()
    
    @Published var accounts: [Account] = []
    @Published var selectedAccount: Account
    
    private init() {
        do {
            container = {
                do {
                    let schema = Schema([Account.self, Trade.self, LinkedBrokerAccount.self, Journal.self])
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
        selectedAccount.trades.append(trade)
        context.insert(trade)
        saveContext()
    }
    
    func deleteTrade(_ trade: Trade) {
        context.delete(trade)
        saveContext()
    }
    
    func getTrades() -> [TradeGroup] {
        let trades = selectedAccount.trades
        return journalManager.smartTradeGrouper.groupTrades(trades)
    }
    
    func linkBrokerAccount(_ brokerAccount: LinkedBrokerAccount) {
        selectedAccount.linkedBrokerAccount = brokerAccount
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
