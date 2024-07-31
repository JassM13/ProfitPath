//
//  ChartData.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 7/31/24.
//

import Foundation

struct ChartData {
    public let date: Date
    public let value: Double
    
    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
