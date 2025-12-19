//
//  InitialDestinationView.swift
//  Motherboard
//
//  Created by Wanhar on 15/12/25.
//

import SwiftUI

// MARK: - Initial Route
enum InitialRoute: Hashable, Identifiable {
    case userRole
    case addChild
    case healthMedicalInfo
    
    var id: String {
        switch self {
        case .userRole:
            return "initial_user_role"
        case .addChild:
            return "initial_add_child"
        case .healthMedicalInfo:
            return "initial_health_medical_info"
        }
    }
}

// MARK: - Initial Destination View
struct InitialDestinationView: View {
    let route: InitialRoute
    
    var body: some View {
        destinationView(for: route)
    }
    
    @ViewBuilder
    private func destinationView(for route: InitialRoute) -> some View {
        switch route {
        case .userRole:
            InitialUserRoleScreenView()
        case .addChild:
            InitialAddChildScreenView()
        case .healthMedicalInfo:
            MainHealthMedicalInfoScreenView()
        }
    }
}
