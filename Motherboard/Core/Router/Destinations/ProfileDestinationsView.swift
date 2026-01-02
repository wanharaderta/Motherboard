//
//  ProfileDestinationsView.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

import SwiftUI

// MARK: - Profile Route
enum ProfileRoute: Hashable, Identifiable {
    case accountDetails
    
    var id: String {
        switch self {
        case .accountDetails:
            return "account_details"
        }
    }
}

// MARK: - Profile Destination View
struct ProfileDestinationsView: View {
    let route: ProfileRoute
    
    var body: some View {
        destinationView(for: route)
    }
    
    @ViewBuilder
    private func destinationView(for route: ProfileRoute) -> some View {
        switch route {
        case .accountDetails:
            AccountDetailsScreenView()
        }
    }
}
