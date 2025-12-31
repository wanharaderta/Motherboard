//
//  CustomBottomNavBar.swift
//  Motherboard
//
//  Created by Wanhar on 25/12/25.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case routine = "Routine"
    case log = "Log"
    case settings = "Settings"
    
    func icon(isActive: Bool) -> String {
        switch self {
        case .home:
            return isActive ? "icHomeActive" : "icHomeInactive"
        case .routine:
            return isActive ? "icRoutineActive" : "icRoutineInactive"
        case .log:
            return isActive ? "icLogActive" : "icLogInactive"
        case .settings:
            return isActive ? "icSettingActive" : "icSettingInactive"
        }
    }
}

struct CustomBottomNavBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            ZStack(alignment: .topTrailing) {
                                Image(tab.icon(isActive: selectedTab == tab))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            .frame(height: 28)
                            
                            Text(tab.rawValue)
                                .appFont(name: .spProDisplay, weight: .medium, size: FontSize.title12)
                                .foregroundStyle(selectedTab == tab ? Color.grey500 : Color.green300)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, Spacing.s)
            
            Spacer()
        }
        .frame(height: 75)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: -2)
    }
}

#Preview {
    CustomBottomNavBar(selectedTab: .constant(.home))
}

