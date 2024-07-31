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
    let id: UUID
    var name: String
    var trades: [Trade] = []
    var linkedBrokerAccount: LinkedBrokerAccount? = nil

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
