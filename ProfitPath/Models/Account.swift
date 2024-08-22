//
//  Account.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import Foundation
import SwiftData

@Model
class Account {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Journal.account)
    var journals: [Journal] = []
    @Relationship(deleteRule: .cascade, inverse: \LinkedBrokerAccount.account)
    var linkedBrokerAccount: LinkedBrokerAccount?
    @Relationship(deleteRule: .cascade, inverse: \TradeGroup.account)
    var tradeGroups: [TradeGroup] = []
    
    init(id: UUID = UUID(), name: String, journals: [Journal] = [], linkedBrokerAccount: LinkedBrokerAccount? = nil, tradeGroups: [TradeGroup] = []) {
        self.id = id
        self.name = name
        self.journals = journals
        self.linkedBrokerAccount = linkedBrokerAccount
        self.tradeGroups = tradeGroups
    }
}
