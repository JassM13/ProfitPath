//
//  LinkedBrokerAccount.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import Foundation

class LinkedBrokerAccount {
    let id: UUID
    var brokerName: String
    var apiKey: String
    
    init(id: UUID = UUID(), brokerName: String, apiKey: String) {
        self.id = id
        self.brokerName = brokerName
        self.apiKey = apiKey
    }
}
