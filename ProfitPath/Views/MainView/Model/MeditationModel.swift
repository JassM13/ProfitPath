//
//  MeditationModel.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 3/23/24.
//

import SwiftUI

struct MeditationModel: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let image: ImageResource
    let background: Color
    let time: Int
    var index: Int
    
    static func ==(lhs: MeditationModel, rhs: MeditationModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
