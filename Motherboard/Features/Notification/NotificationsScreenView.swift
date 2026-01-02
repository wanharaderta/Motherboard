//
//  NotificationsScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 31/12/25.
//

import SwiftUI

struct NotificationsScreenView: View {
    
    // MARK: - Properties
    @Environment(Router.self) private var router
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                contentView
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Header
    private var headerView: some View {
        BaseHeaderView(title: "Notifications", onBack: {
            router.pop()
        })
    }
    
    // MARK: - Content
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Spacing.l) {
                // TODO: Add notification list content here
                Text("Notifications")
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title20)
                    .foregroundColor(Color.black400)
                    .padding()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, Spacing.m)
        }
    }
}

#Preview {
    NotificationsScreenView()
        .environment(Router())
}
