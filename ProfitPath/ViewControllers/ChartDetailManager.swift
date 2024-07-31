//
//  ChartDetailManager.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import SwiftUI
import Combine

class ChartDetailManager: ObservableObject {
    static var shared = ChartDetailManager()
    
    @Published var isTouching: Bool = false
    @Published var detailText: String = ""
    @Published var touchLocation: CGPoint = .zero
}
