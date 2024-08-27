//
//  UserData.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import Foundation
import SwiftData

@Model
class UserData {
    @Attribute var id: UUID = UUID()
    @Attribute var accounts: [Account]
    
    init(id: UUID = UUID(), accounts: [Account] = []) {
        self.id = id
        self.accounts = accounts
    }
}
