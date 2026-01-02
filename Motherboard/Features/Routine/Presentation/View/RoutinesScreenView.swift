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
    @State private var viewModel = RoutinesViewModel()
    
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
                RoutinesDestinationsView(route: route)
                    .environment(router)
            }
            .onAppear {
                viewModel.fetchRoutines()
            }
            .onDisappear {
                viewModel.removeListener()
            }
        }
    }
    
    // MARK: - Header View
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
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            dailyRoutinesSection
            scheduledRoutinesSection
        }
        .alert(Constants.errorString, isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(Constants.okString.uppercased()) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - Sub View
extension RoutinesScreenView {
    
    // MARK: - Daily Routines Section
    private var dailyRoutinesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            Text(Constants.manageDailyRoutines)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                .foregroundStyle(Color.mineShaft.opacity(0.86))
            
            VStack(spacing: Spacing.m) {
                ForEach(RoutineType.allCases) { routine in
                    ItemDailyRoutineCellView(routine: routine) { item in
                        handleRoutineTypeSelection(item)
                    }
                }
            }
        }
    }
    
    // MARK: - Scheduled Routines Section
    private var scheduledRoutinesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            Text(Constants.manageScheduledRoutines)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                .foregroundStyle(Color.mineShaft.opacity(0.86))
            
            if viewModel.routines.isEmpty {
                emptyStateView
            } else {
                routinesListView
            }
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: Spacing.l) {
            Spacer()
                .frame(height: Spacing.xxl)
            
            Image("icEmptyRoutines")
                .resizable()
                .frame(width: 89, height: 89)
            
            VStack(spacing: Spacing.xs) {
                Text(Constants.noRoutinesAddedYet)
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title16)
                    .foregroundStyle(Color.mineShaft.opacity(0.8))
                
                Text(Constants.createRoutinesDescription)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                    .foregroundStyle(Color.mineShaft.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                    .lineLimit(nil)
            }
            
            Spacer()
                .frame(height: Spacing.xxl)
        }
        .customCardView(color: Color.green50, cornerRadius: 12)
    }
    
    // MARK: - Routines List View
    private var routinesListView: some View {
        VStack(spacing: Spacing.m) {
            ForEach(viewModel.routines) { routine in
                ItemScheduledRoutineCellView(
                    routine: routine,
                    onEdit: {},
                    onDelete: {}
                )
            }
        }
    }
}

// MARK: - Helpers {
extension RoutinesScreenView {
    private func handleRoutineTypeSelection(_ item: RoutineType) {
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
        router.replace(with: targetRoute)
    }
}

#Preview {
    RoutinesScreenView()
}
