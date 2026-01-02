//
//  RoutinesDestinationView.swift
//  Motherboard
//
//  Created by Wanhar on 24/12/25.
//

import SwiftUI

// MARK: - Routines Route
enum RoutinesRoute: Hashable, Identifiable {
    case createMealsAndBottles
    case createDiapers
    case createMedications
    case createBreastfeeding
    case successRoutine
    
    var id: String {
        switch self {
        case .createMealsAndBottles:
            return "create_meals_and_bottles"
        case .createDiapers:
            return "create_diapers"
        case .createMedications:
            return "create_medications"
        case .createBreastfeeding:
            return "create_breastfeeding"
        case .successRoutine:
            return "success_routine"
        }
    }
}

// MARK: - Routines Destination View
struct RoutinesDestinationsView: View {
    let route: RoutinesRoute
    
    var body: some View {
        destinationView(for: route)
    }
    
    @ViewBuilder
    private func destinationView(for route: RoutinesRoute) -> some View {
        switch route {
        case .createMealsAndBottles:
            CreateMealsAndBottlesScreenView()
        case .createDiapers:
            CreateDiapersScreenView()
        case .createMedications:
            CreateMedicationsScreenView()
        case .createBreastfeeding:
            BreastfeedingScreenView()
        case .successRoutine:
            SuccessScreenView()
        }
    }
}
