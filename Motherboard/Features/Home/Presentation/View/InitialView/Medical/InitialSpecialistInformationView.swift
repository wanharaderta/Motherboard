//
//  OnboardingSpecialistInformationView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

struct InitialSpecialistInformationView: View {
    
    // MARK: - Properties
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    @Environment(InitialViewModel.self) private var initialViewModel
    @FocusState private var focusedField: Field?
    
    // MARK: - Enums
    
    enum Field {
        case doctorName
        case practiceName
        case phone
        case address
        case portalLink
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
        Text(Constants.pediatricianSpecialistInformation)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
    }
    
    // MARK: - Specialist Information Section
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            doctorNameField
            practiceNameField
            phoneField
            addressField
            portalLinkField
        }
        .padding(Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Doctor Name Field
    
    private var doctorNameField: some View {
        LabeledInputField(
            label: Constants.doctorName,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.doctorName }, set: { initialViewModel.doctorName = $0 }),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .doctorName,
            focus: $focusedField
        )
    }
    
    // MARK: - Practice Name Field
    
    private var practiceNameField: some View {
        LabeledInputField(
            label: Constants.practiceName,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.practiceName }, set: { initialViewModel.practiceName = $0 }),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .practiceName,
            focus: $focusedField
        )
    }
    
    // MARK: - Phone Field
    
    private var phoneField: some View {
        LabeledInputField(
            label: Constants.phone,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.specialistPhone }, set: { initialViewModel.specialistPhone = $0 }),
            keyboardType: .phonePad,
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .phone,
            focus: $focusedField
        )
    }
    
    // MARK: - Address Field
    
    private var addressField: some View {
        LabeledInputField(
            label: Constants.address,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.specialistAddress }, set: { initialViewModel.specialistAddress = $0 }),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .address,
            focus: $focusedField
        )
    }
    
    // MARK: - Portal Link Field
    
    private var portalLinkField: some View {
        LabeledInputField(
            label: Constants.portalLinkOptional,
            placeholder: Constants.enterLinkURL,
            text: Binding(get: { initialViewModel.portalLink }, set: { initialViewModel.portalLink = $0 }),
            keyboardType: .URL,
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .portalLink,
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

extension InitialSpecialistInformationView {
    private func handleContinue() {
        // All fields are optional for specialist information, so we can always continue
        onContinue?()
    }
}
