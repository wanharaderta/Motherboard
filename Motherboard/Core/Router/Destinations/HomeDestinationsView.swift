//
//  HomeDestinationsView.swift
//  Motherboard
//
//  Created by Wanhar on 31/12/25.
//

import SwiftUI

// MARK: - Home Route
enum HomeRoute: Hashable, Identifiable {
    case notifications
    
    var id: String {
        switch self {
        case .notifications:
            return "notifications"
        }
    }
}

// MARK: - Home Destination View
struct HomeDestinationsView: View {
    let route: HomeRoute
    
    var body: some View {
        destinationView(for: route)
    }
    
    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .notifications:
            NotificationsScreenView()
        }
    }
}
