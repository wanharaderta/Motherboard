//
//  OnboardingEmergencyMedicationView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

struct InitialEmergencyMedicationView: View {
    
    // MARK: - Properties
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    @Environment(InitialViewModel.self) private var initialViewModel
    @FocusState private var focusedField: Field?
    
    // MARK: - Enums
    
    enum Field {
        case autoInjectorBrand
        case dose
        case whenToAdminister
        case followUpSteps
        case instructionalYouTubeLink
        case doctorContact
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.m) {
                headerView
                contentView
                continueButton
                
                Spacer()
                    .frame(height: Spacing.xl)
            }
            .padding([.top, .horizontal], Spacing.xl)
        }
        .background(Color.white.ignoresSafeArea())
        .alert(Constants.error, isPresented: Binding(get: { initialViewModel.isError }, set: { if !$0 { initialViewModel.clearError() } })) {
            Button(Constants.ok) {
                initialViewModel.clearError()
            }
        } message: {
            Text(initialViewModel.errorMessage ?? Constants.errorOccurred)
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        Text(Constants.epipenEmergencyMedicationInstructions)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
    }
    
    // MARK: - Emergency Medication Section
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            autoInjectorBrandField
            doseField
            whenToAdministerField
            followUpStepsField
            instructionalYouTubeLinkField
            doctorContactField
        }
        .padding(Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Auto-injector Brand Field
    
    private var autoInjectorBrandField: some View {
        LabeledInputField(
            label: Constants.autoInjectorBrand,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.autoInjectorBrand }, set: { initialViewModel.autoInjectorBrand = $0 }),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .autoInjectorBrand,
            focus: $focusedField
        )
    }
    
    // MARK: - Dose Field
    
    private var doseField: some View {
        MenuField(
            label: Constants.dose,
            selectedValue: Binding(get: { initialViewModel.emergencyDose }, set: { initialViewModel.emergencyDose = $0 }),
            field: Field.dose,
            focus: $focusedField
        )
    }
    
    // MARK: - When to Administer Field
    
    private var whenToAdministerField: some View {
        LabeledInputField(
            label: Constants.whenToAdminister,
            placeholder: Constants.forAnaphylaxisSigns,
            text: Binding(get: { initialViewModel.whenToAdminister }, set: { initialViewModel.whenToAdminister = $0 }),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .whenToAdminister,
            focus: $focusedField
        )
    }
    
    // MARK: - Follow Up Steps Field
    
    private var followUpStepsField: some View {
        LabeledInputField(
            label: Constants.followUpSteps,
            placeholder: Constants.call911,
            text: Binding(get: { initialViewModel.followUpSteps }, set: { initialViewModel.followUpSteps = $0 }),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .followUpSteps,
            focus: $focusedField
        )
    }
    
    // MARK: - Instructional YouTube Link Field
    
    private var instructionalYouTubeLinkField: some View {
        LabeledInputField(
            label: Constants.instructionalYouTubeLink,
            placeholder: Constants.enterLinkURL,
            text: Binding(get: { initialViewModel.instructionalYouTubeLink }, set: { initialViewModel.instructionalYouTubeLink = $0 }),
            keyboardType: .URL,
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .instructionalYouTubeLink,
            focus: $focusedField
        )
    }
    
    // MARK: - Doctor Contact Field
    
    private var doctorContactField: some View {
        LabeledInputField(
            label: Constants.doctorContact,
            placeholder: Constants.kindlyProvideDoctorsContact,
            text: Binding(get: { initialViewModel.doctorContact }, set: { initialViewModel.doctorContact = $0 }),
            keyboardType: .phonePad,
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .doctorContact,
            focus: $focusedField
        )
    }
    
    // MARK: - Continue Button
    
    private var continueButton: some View {
        Button(action: {
            handleContinue()
        }) {
            Text(Constants.continueString)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                .foregroundColor(Color.green500)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green500, lineWidth: 1)
                )
        }
        .padding(.vertical, Spacing.xl)
    }
    
}

// MARK: - Helper Methods

extension InitialEmergencyMedicationView {
    private func handleContinue() {
        // All fields are optional for emergency medication, so we can always continue
        onContinue?()
    }
}
