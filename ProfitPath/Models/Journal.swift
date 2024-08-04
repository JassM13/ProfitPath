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
    var notes: String
    var images: [Data]
    
    init(notes: String = "", images: [Data] = []) {
        self.notes = notes
        self.images = images
    }
}
