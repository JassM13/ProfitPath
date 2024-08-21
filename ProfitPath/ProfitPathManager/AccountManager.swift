//
//  AccountManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/20/24.
//

import Foundation
import CoreData

@MainActor
class AccountManager: ObservableObject {
    static let shared = AccountManager()
    
    @Published var accounts: [Account] = []
    @Published var selectedAccount: Account {
        didSet {
            // Debugging output to track changes
            print("Selected account changed:")
            print("Old account: \(oldValue)")
            print("New account: \(selectedAccount)")
        }
    }
    
    private let accountRepository = AccountRepository.shared
    
    private init() {
            let fetchedAccounts = accountRepository.fetchAccounts()
            if fetchedAccounts.isEmpty {
                let defaultAccount = Account(id: UUID(), name: "Default Account")
                accountRepository.saveAccount(defaultAccount)
                self.accounts = [defaultAccount]
                self.selectedAccount = defaultAccount
            } else {
                self.accounts = fetchedAccounts
                self.selectedAccount = fetchedAccounts[0]
            }
        }
    
    func createAccount(name: String) {
        let newAccount = Account(id: UUID(), name: name)
        accountRepository.saveAccount(newAccount)
        accounts.append(newAccount)
        objectWillChange.send()
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
        accountRepository.saveAccount(selectedAccount)
        objectWillChange.send()
    }
    
    func deleteTradeGroup(_ tradeGroup: TradeGroup) {
        if let index = selectedAccount.tradeGroups.firstIndex(where: { $0.id == tradeGroup.id }) {
            selectedAccount.tradeGroups.remove(at: index)
        }
        accountRepository.saveAccount(selectedAccount)
        objectWillChange.send()
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
        
        accountRepository.saveAccount(selectedAccount)
    }
    
    func addJournalEntryToTradeGroup(group: TradeGroup, content: Data) {
        let newEntry = JournalEntry(content: content)
        group.journalEntry = newEntry
        accountRepository.saveAccount(selectedAccount)
    }
    
    func deleteAccount(_ account: Account) {
        guard accounts.count > 1 else {
            print("Cannot delete the last account.")
            createAccount(name: "Default Account")
            return deleteAccount()
        }
        
        deleteAccount()
        func deleteAccount() {
            if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                accounts.remove(at: index)
            }
            if selectedAccount.id == account.id {
                selectedAccount = accounts.first!
            }
            accountRepository.clearAccounts()
            accounts.forEach { accountRepository.saveAccount($0) }
        }
        objectWillChange.send()
    }
}
