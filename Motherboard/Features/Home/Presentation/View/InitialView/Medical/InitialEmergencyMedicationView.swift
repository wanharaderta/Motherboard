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
    @Environment(InitialViewModel.self) private var viewModel
    @FocusState private var focusedField: Field?
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    // MARK: - Enums
    enum Field {
        case autoInjectorBrand
        case dose
        case whenToAdminister
        case followUpSteps
        case instructionalYouTubeLink
        case doctorContact
    }
    
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
        .alert(Constants.error, isPresented: Binding(get: { viewModel.isError }, set: { if !$0 { viewModel.clearError() } })) {
            Button(Constants.ok) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? Constants.errorOccurred)
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
}

// MARK: - Item View
extension InitialEmergencyMedicationView {
    // MARK: - Auto-injector Brand Field
    private var autoInjectorBrandField: some View {
        LabeledInputField(
            label: Constants.autoInjectorBrand,
            placeholder: Constants.placeholder,
            text: Binding(
                get: { viewModel.emergencyMedicationRequest.autoInjectorBrand ?? "" },
                set: { viewModel.emergencyMedicationRequest.autoInjectorBrand = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
            bgPlaceholderColor: Color.green50,
            field: .autoInjectorBrand,
            focus: $focusedField
        )
    }
    
    // MARK: - Dose Field
    private var doseField: some View {
        MenuField(
            label: Constants.dose,
            selectedValue: Binding(
                get: { viewModel.emergencyMedicationRequest.emergencyDose ?? .mgML },
                set: { viewModel.emergencyMedicationRequest.emergencyDose = $0 }
            ),
            field: Field.dose,
            focus: $focusedField
        )
    }
    
    // MARK: - When to Administer Field
    private var whenToAdministerField: some View {
        LabeledInputField(
            label: Constants.whenToAdminister,
            placeholder: Constants.forAnaphylaxisSigns,
            text: Binding(
                get: { viewModel.emergencyMedicationRequest.whenToAdminister ?? "" },
                set: { viewModel.emergencyMedicationRequest.whenToAdminister = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.emergencyMedicationRequest.followUpSteps ?? "" },
                set: { viewModel.emergencyMedicationRequest.followUpSteps = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.emergencyMedicationRequest.instructionalYouTubeLink ?? "" },
                set: { viewModel.emergencyMedicationRequest.instructionalYouTubeLink = $0 }
            ),
            keyboardType: .URL,
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.emergencyMedicationRequest.doctorContact ?? "" },
                set: { viewModel.emergencyMedicationRequest.doctorContact = $0 }
            ),
            keyboardType: .phonePad,
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
            bgPlaceholderColor: Color.green50,
            field: .doctorContact,
            focus: $focusedField
        )
    }
    
    private var continueButton: some View {
        Button(action: {
            onContinue?()
        }) {
            Text(Constants.continueString)
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
}

// MARK: - Helper Methods

extension InitialEmergencyMedicationView {
    
    private var isFormValid: Bool {
        let autoInjectorBrand = (viewModel.emergencyMedicationRequest.autoInjectorBrand ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let whenToAdminister = (viewModel.emergencyMedicationRequest.whenToAdminister ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let followUpSteps = (viewModel.emergencyMedicationRequest.followUpSteps ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let instructionalYouTubeLink = (viewModel.emergencyMedicationRequest.instructionalYouTubeLink ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let doctorContact = (viewModel.emergencyMedicationRequest.doctorContact ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !autoInjectorBrand.isEmpty &&
               !whenToAdminister.isEmpty &&
               !followUpSteps.isEmpty &&
               !instructionalYouTubeLink.isEmpty &&
               !doctorContact.isEmpty
    }
}
