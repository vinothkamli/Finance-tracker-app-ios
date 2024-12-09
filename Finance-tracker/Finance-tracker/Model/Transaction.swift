//
//  Transaction.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Transaction {
    ///Properties
    var title: String
    var remark: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    init(title: String, remark: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remark = remark
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Extracting Color value from tintCOlor string
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor})?.value ?? appTint
    }
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor})
    }
    @Transient
    var rawCatgory: Category? {
        return Category.allCases.first(where: { category == $0.rawValue})
    }
}
