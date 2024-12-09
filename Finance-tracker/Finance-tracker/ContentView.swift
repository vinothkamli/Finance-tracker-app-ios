//
//  ContentView.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false

    /// Active Tap
    @State private var activeTap: Tap = .recents
    var body: some View {
        
        LockView(lockType: . both, lockPin: "1234", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection: $activeTap,
                    content:  {
                Recents()
                    .tag(Tap.recents)
                    .tabItem { Tap.recents.tabContent }
                
                Search()
                    .tag(Tap.search)
                    .tabItem { Tap.search.tabContent }
                
                Graphs()
                    .tag(Tap.charts)
                    .tabItem { Tap.charts.tabContent }
                
                Settings()
                    .tag(Tap.settings)
                    .tabItem { Tap.settings.tabContent }
            })
            .background(.red)
            .tint(appTint)
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        }
    }
}

