//
//  LinkedBrokerAccount.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import Foundation
import SwiftData

@Model
class LinkedBrokerAccount {
    var id: UUID
    var apiKey: String?
    var brokerName: String?
    @Attribute(.externalStorage)
    var account: Account?
    
    init(id: UUID = UUID(), apiKey: String? = nil, brokerName: String? = nil) {
        self.id = id
        self.apiKey = apiKey
        self.brokerName = brokerName
    }
}
