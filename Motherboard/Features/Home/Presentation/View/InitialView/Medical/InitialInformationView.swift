//
//  OnboardingSpecialistInformationView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

struct InitialInformationView: View {
    
    // MARK: - Properties
    @Environment(InitialViewModel.self) private var viewModel
    @FocusState private var focusedField: Field?
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    // MARK: - Enums
    enum Field {
        case doctorName
        case practiceName
        case phone
        case address
        case portalLink
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
}

// MARK: - Item View
extension InitialInformationView {
    // MARK: - Doctor Name Field
    private var doctorNameField: some View {
        LabeledInputField(
            label: Constants.doctorName,
            placeholder: Constants.placeholder,
            text: Binding(
                get: { viewModel.infoModelRequest.doctorName ?? "" },
                set: { viewModel.infoModelRequest.doctorName = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.infoModelRequest.practiceName ?? "" },
                set: { viewModel.infoModelRequest.practiceName = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.infoModelRequest.specialistPhone ?? "" },
                set: { viewModel.infoModelRequest.specialistPhone = $0 }
            ),
            keyboardType: .phonePad,
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.infoModelRequest.specialistAddress ?? "" },
                set: { viewModel.infoModelRequest.specialistAddress = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
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
            text: Binding(
                get: { viewModel.infoModelRequest.portalLink ?? "" },
                set: { viewModel.infoModelRequest.portalLink = $0 }
            ),
            keyboardType: .URL,
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
            bgPlaceholderColor: Color.green50,
            field: .portalLink,
            focus: $focusedField
        )
    }
    
    private var continueButton: some View {
        Button(action: {
            focusedField = nil
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

extension InitialInformationView {
    
    private var isFormValid: Bool {
        let doctorName = (viewModel.infoModelRequest.doctorName ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let practiceName = (viewModel.infoModelRequest.practiceName ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let specialistPhone = (viewModel.infoModelRequest.specialistPhone ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let specialistAddress = (viewModel.infoModelRequest.specialistAddress ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !doctorName.isEmpty &&
               !practiceName.isEmpty &&
               !specialistPhone.isEmpty &&
               !specialistAddress.isEmpty
    }
}
