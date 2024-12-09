//
//  TintColor.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import Foundation
import SwiftUI

struct TintColor: Identifiable {
    let id: UUID = .init()
    
    var color: String
    var value: Color
}

var tints: [TintColor] = [
    .init(color: "red", value: .red),
    .init(color: "blue", value: .blue),
    .init(color: "pink", value: .pink),
    .init(color: "purple", value: .purple),
    .init(color: "brown", value: .brown),
    .init(color: "orange", value: .orange)
]
