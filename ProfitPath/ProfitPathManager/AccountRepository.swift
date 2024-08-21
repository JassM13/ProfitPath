//
//  AccountRepository.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/20/24.
//

import Foundation
import CoreData

class AccountRepository {
    static let shared = AccountRepository()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AccountModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveAccount(_ account: Account) {
        let context = persistentContainer.viewContext
        
        let entity = AccountEntity(context: context)
        entity.id = account.id
        entity.name = account.name
        
        // Save related entities (TradeGroup, Journal, LinkedBrokerAccount)
        for tradeGroup in account.tradeGroups {
            let tradeGroupEntity = TradeGroupEntity(context: context)
            tradeGroupEntity.id = tradeGroup.id
            tradeGroupEntity.account = entity
        }
        
        for journal in account.journals {
            let journalEntity = JournalEntity(context: context)
            journalEntity.id = journal.id
            journalEntity.title = journal.title
            journalEntity.account = entity
        }
        
        if let linkedBrokerAccount = account.linkedBrokerAccount {
            let linkedBrokerAccountEntity = LinkedBrokerAccountEntity(context: context)
            linkedBrokerAccountEntity.id = linkedBrokerAccount.id
            linkedBrokerAccountEntity.account = entity
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save account: \(error)")
        }
    }
    
    func fetchAccounts() -> [Account] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { entity in
                guard let id = entity.id, let name = entity.name else {
                    return nil
                }

                let account = Account(id: id, name: name)

                // Fetch related entities (TradeGroup, Journal, LinkedBrokerAccount)
                account.tradeGroups = entity.tradeGroups?.allObjects as? [TradeGroup] ?? []
                account.journals = entity.journals?.allObjects as? [Journal] ?? []
                account.linkedBrokerAccount = entity.linkedBrokerAccount as? LinkedBrokerAccount

                return account
            }
        } catch {
            print("Failed to fetch accounts: \(error)")
            return []
        }
    }
    
    func clearAccounts() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AccountEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Accounts cleared successfully")
        } catch {
            print("Error clearing accounts: \(error)")
        }
    }
}
