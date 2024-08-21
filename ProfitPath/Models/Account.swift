//
//  Account.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import Foundation

class Account: Identifiable {
    var id: UUID
    var name: String
    var tradeGroups: [TradeGroup] = []
    var journals: [Journal] = []
    var linkedBrokerAccount: LinkedBrokerAccount?

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
