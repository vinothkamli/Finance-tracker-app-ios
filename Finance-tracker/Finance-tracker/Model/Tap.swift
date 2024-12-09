//
//  Tap.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import Foundation
import SwiftUI

enum Tap: String {
    case recents = "Recents"
    case search = "Filters"
    case charts = "Charts"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .recents :
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .search :
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)

        case .charts :
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)

        case .settings :
            Image(systemName: "gearshape")
            Text(self.rawValue)

        }
    }
}
