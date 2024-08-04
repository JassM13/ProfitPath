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
    @Attribute(.unique) let id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var trades: [Trade] = []
    @Relationship(deleteRule: .nullify) var linkedBrokerAccount: LinkedBrokerAccount?

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
