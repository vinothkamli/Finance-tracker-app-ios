//
//  ChartModel.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import Foundation
import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: Category
}
