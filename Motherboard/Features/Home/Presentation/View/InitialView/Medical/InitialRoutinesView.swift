//
//  OnboardingRoutinesView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

// MARK: - Routine Type

enum RoutineType: String, CaseIterable, Identifiable {
    case bottlesAndMeals
    case medications
    case diapers
    case breastfeedingAndPumping
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .bottlesAndMeals:
            return Constants.bottlesAndMeals
        case .medications:
            return Constants.medicationsRoutine
        case .diapers:
            return Constants.diapers
        case .breastfeedingAndPumping:
            return Constants.breastfeedingAndPumping
        }
    }
    
    var description: String {
        switch self {
        case .bottlesAndMeals:
            return Constants.bottlesAndMealsDescription
        case .medications:
            return Constants.medicationsRoutineDescription
        case .diapers:
            return Constants.diapersDescription
        case .breastfeedingAndPumping:
            return Constants.breastfeedingAndPumpingDescription
        }
    }
    
    var iconName: String {
        switch self {
        case .bottlesAndMeals:
            return "icBabyBottle"
        case .medications:
            return "icPharma"
        case .diapers:
            return "icNappy"
        case .breastfeedingAndPumping:
            return "icPersonWomen"
        }
    }
    
    var iconBackgroundColor: Color {
        switch self {
        case .bottlesAndMeals:
            return Color.bgPampas
        case .medications:
            return Color.bgPastelPink
        case .diapers:
            return Color.bgBlueChalk
        case .breastfeedingAndPumping:
            return Color.bgCherub
        }
    }
}

struct InitialRoutinesView: View {
    
    // MARK: - Properties
    @Environment(InitialViewModel.self) private var initialViewModel
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    @FocusState private var focusedField: Field?
    
    // MARK: - Enums
    
    enum Field {
        case none
    }
    
    // MARK: - Body
    
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
                        get: { initialViewModel.selectedRoutines },
                        set: { initialViewModel.selectedRoutines = $0 }
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.black300)
                    .frame(width: 20)
                
                Text(Constants.createACustomRoutine)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.grey500)
            }
            .padding(Spacing.m)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderNeutralWhite, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Proceed Button
    
    private var proceedButton: some View {
        Button(action: {
            handleContinue()
        }) {
            Text(Constants.proceed)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
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
        .disabled(!isFormValid)
        .padding(.vertical, Spacing.xl)
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !initialViewModel.selectedRoutines.isEmpty
    }
    
}

// MARK: - Helper Methods

extension InitialRoutinesView {
    private func handleContinue() {
        guard isFormValid else {
            return
        }
        
        onContinue?()
    }
}
