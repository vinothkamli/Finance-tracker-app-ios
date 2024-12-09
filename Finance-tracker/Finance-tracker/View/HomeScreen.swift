//
//  HomeScreen.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // Custom Tab Bar
            TabView(selection: $selectedTab) {
                Text("Tab 1 Content")
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                Text("Tab 2 Content")
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(1)
                
                Text("Tab 3 Content")
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                Text("Tab 4 Content")
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(1)
            }
            .accentColor(.blue)
        }
    }
}


#Preview {
    HomeScreen()
}
