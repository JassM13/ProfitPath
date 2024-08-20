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
    var title: String
    var createdAt: Date
    var entries: [JournalEntry] = []

    init(id: UUID = UUID(), title: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}

@Model
class JournalEntry {
    var id: UUID
    var content: Data
    var createdAt: Date

    init(id: UUID = UUID(), content: Data, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
    }
}
