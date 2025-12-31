//
//  RoutinesScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 23/12/25.
//

import SwiftUI

struct RoutinesScreenView: View {
    
    // MARK: - Properties
    @State private var router = Router()
    
    private let scheduledRoutines: [ScheduledRoutine] = [
        .init(timeRange: "07:00 - 09:00AM", note: "Sonia's having a short nap"),
        .init(timeRange: "07:00 - 09:00AM", note: "Sonia's having a short nap"),
        .init(timeRange: "07:00 - 09:00AM", note: "Sonia's having a short nap")
    ]
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            VStack(spacing: 0) {
                headerView
                
                ScrollView(.vertical, showsIndicators: false) {
                    contentView
                        .padding(.horizontal, Spacing.l)
                        .padding(.vertical, Spacing.l)
                }
                .background(Color.white)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.vertical)
            .navigationDestination(for: RoutinesRoute.self) { route in
                RoutinesDestinationView(route: route)
                    .environment(router)
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            
            Spacer()
                .frame(height: 40)
            
            Text(Constants.routines)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundStyle(Color.green50)
        }
        .frame(maxWidth: .infinity, maxHeight: 106)
        .background(Color.primaryGreen900)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.manageDailyRoutines)
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                    .foregroundStyle(Color.mineShaft.opacity(0.86))
            }
            
            VStack(spacing: Spacing.m) {
                ForEach(RoutineType.allCases) { routine in
                    ItemDailyRoutineCellView(routine: routine) { item in
                        let targetRoute: RoutinesRoute
                        switch item {
                        case .bottlesAndMeals:
                            targetRoute = .createMealsAndBottles
                        case .diapers:
                            targetRoute = .createDiapers
                        case .medications:
                            targetRoute = .createMedications
                        case .breastfeedingAndPumping:
                            targetRoute = .createBreastfeeding
                        }
                        // Use replace to ensure clean navigation state
                        // This prevents blank screen issues when tapping menu items after returning
                        router.replace(with: targetRoute)
                    }
                }
            }
            
            Text(Constants.manageScheduledRoutines)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                .foregroundStyle(Color.mineShaft.opacity(0.86))
                .padding(.top, Spacing.xl)
            
            VStack(spacing: Spacing.m) {
                ForEach(scheduledRoutines) { routine in
                    ItemScheduledRoutineCellView(
                        routine: routine,
                        onEdit: {},
                        onDelete: {}
                    )
                }
            }
        }
    }
}

#Preview {
    RoutinesScreenView()
}

// MARK: - Models

struct ScheduledRoutine: Identifiable {
    let id: UUID
    let timeRange: String
    let note: String
    
    init(id: UUID = UUID(), timeRange: String, note: String) {
        self.id = id
        self.timeRange = timeRange
        self.note = note
    }
}
