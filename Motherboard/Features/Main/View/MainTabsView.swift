//
//  MainTabsView.swift
//  Motherboard
//
//  Created by Cursor on 23/12/25.
//

import SwiftUI

/// Hosts the main tab-based navigation for the app.
struct MainTabsView: View {
    
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .home:
                    HomeScreenView()
                case .routine:
                    RoutinesScreenView()
                case .log:
                    // TODO: Replace with real log screen once available.
                    Text("Log Screen")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                case .settings:
                    // TODO: Replace with real settings screen once available.
                    Text("Settings Screen")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                }
            }
            CustomBottomNavBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainTabsView()
}
