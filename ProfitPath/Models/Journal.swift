//
//  Journal.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/3/24.
//

import Foundation
import SwiftData

@Model
class Journal {
    var id: UUID
    var title: String?
    var createdAt: Date?
    @Attribute(.externalStorage)
    var account: Account?
    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.journal)
    var entries: [JournalEntry]?
    
    init(id: UUID = UUID(), title: String? = nil, createdAt: Date? = Date()) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}

@Model
class JournalEntry {
    var id: UUID
    var content: Data?
    var createdAt: Date?
    @Attribute(.externalStorage)
    var journal: Journal?
    @Attribute(.externalStorage)
    var tradeGroups: TradeGroup?
    
    init(id: UUID = UUID(), content: Data? = nil, createdAt: Date? = Date()) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
    }
}
