//
//  User.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import Foundation
import SwiftData

@Model
class User {
    @Attribute var id: UUID = UUID()
    @Attribute var email: String
    @Attribute var hashedPassword: String
    @Attribute var createdAt: Date = Date()
    @Attribute var updatedAt: Date = Date()
    
    init(email: String, hashedPassword: String) {
        self.email = email
        self.hashedPassword = hashedPassword
    }
}
