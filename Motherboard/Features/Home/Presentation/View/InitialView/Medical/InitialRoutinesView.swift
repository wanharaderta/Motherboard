//
//  OnboardingRoutinesView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

// MARK: - Routine Type
struct InitialRoutinesView: View {
    
    // MARK: - Properties
    @Environment(InitialViewModel.self) private var viewModel
    @Environment(Router.self) private var navigationCoordinator
    @AppStorage(Enums.hasCompletedInitialData.rawValue) private var hasCompletedInitialData: Bool = false
    @FocusState private var focusedField: Field?
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    enum Field {
        case none
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.m) {
                routinesList
                createCustomRoutineButton
                proceedButton
                
                Spacer()
                    .frame(height: Spacing.xl)
            }
            .padding([.top, .horizontal], Spacing.xl)
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Routines List
    private var routinesList: some View {
        VStack(spacing: Spacing.m) {
            ForEach(RoutineType.allCases) { routine in
                ItemRoutinesCellView(
                    routine: routine,
                    selectedRoutines: Binding(
                        get: { viewModel.selectedRoutines },
                        set: { viewModel.selectedRoutines = $0 }
                    )
                )
            }
        }
    }
    
    // MARK: - Create Custom Routine Button
    
    private var createCustomRoutineButton: some View {
        Button(action: {
            // Handle create custom routine
        }) {
            HStack(spacing: Spacing.m) {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.primaryGreen900)
                
                Text(Constants.createACustomRoutine)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                    .foregroundColor(Color.mineShaft.opacity(0.8))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.primaryGreen900)
            }
            .padding(.horizontal, Spacing.m)
            .frame(height: 66)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green500, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var proceedButton: some View {
        Button(action: {
            Task { @MainActor in
                await viewModel.addChild()
                if !viewModel.isError {
                    hasCompletedInitialData = true
                    
                    // Navigate to home
                    navigationCoordinator.replace(with: MainDestinationsView.home)
                }
            }
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                } else {
                    Text(Constants.proceed)
                        .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                }
            }
            .foregroundColor(isFormValid ? Color.white : Color.green500)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isFormValid ? Color.primaryGreen900 : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFormValid ? Color.white : Color.green500,
                        lineWidth: 1
                    )
            )
        }
        .disabled(!isFormValid || viewModel.isLoading)
        .padding(.vertical, Spacing.xl)
    }
}

// MARK: - Helper Methods

extension InitialRoutinesView {
    private var isFormValid: Bool {
        !viewModel.selectedRoutines.isEmpty
    }
}
