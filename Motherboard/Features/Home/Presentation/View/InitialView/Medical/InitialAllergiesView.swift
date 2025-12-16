//
//  AllergiesHealthMedicalView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

struct InitialAllergiesView: View {
    
    // MARK: - Properties
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    @Environment(InitialViewModel.self) private var initialViewModel
    @FocusState private var focusedField: Field?
    
    // MARK: - Enums
    enum Field {
        case allergyName, severity, triggerDetails, reactionDescription, specificInstructions
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
        .alert(Constants.error, isPresented: Binding(get: { initialViewModel.isError }, set: { if !$0 { initialViewModel.clearError() } })) {
            Button(Constants.ok) {
                initialViewModel.clearError()
            }
        } message: {
            Text(initialViewModel.errorMessage ?? Constants.errorOccurred)
        }
    }
    
    private var headerView: some View {
        Text(Constants.allergies)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
           // .padding(.top, Spacing.s)
    }
    
    // MARK: - Allergies Section
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            allergyNameField
            severityField
            triggerDetailsField
            reactionDescriptionField
            specificInstructionsField
        }
        .padding(Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Allergy Name Field
    private var allergyNameField: some View {
        LabeledInputField(
            label: Constants.allergyName,
            placeholder: Constants.placeholder,
            text: Binding(
                get: { initialViewModel.allergyRequest.allergyName ?? "" },
                set: { initialViewModel.allergyRequest.allergyName = $0 }
            ),
            textPlaceholderColor: Color.mainGray,
            bgPlaceholderColor: Color.green50,
            field: .allergyName,
            focus: $focusedField,
        )
    }
    
    // MARK: - Severity Field
    private var severityField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.severity)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            Menu {
                ForEach(AllergySeverity.allCases, id: \.self) { severityOption in
                    Button(action: {
                        initialViewModel.allergyRequest.severity = severityOption
                    }) {
                        HStack {
                            Text(severityOption.displayName)
                            
                            if initialViewModel.allergyRequest.severity == severityOption {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text((initialViewModel.allergyRequest.severity ?? .mild).displayName)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .foregroundColor(Color.tundora)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.tundora)
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .severity ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
            }
            .onTapGesture {
                focusedField = .severity
            }
        }
    }
    
    // MARK: - Trigger Details Field
    private var triggerDetailsField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.triggerDetails)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextEditor(
                text: Binding(
                    get: { initialViewModel.allergyRequest.triggerDetails ?? "" },
                    set: { initialViewModel.allergyRequest.triggerDetails = $0 }
                )
            )
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .padding(Spacing.m)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .triggerDetails ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .overlay(
                    Group {
                        if (initialViewModel.allergyRequest.triggerDetails ?? "").isEmpty {
                            VStack {
                                HStack {
                                    Text(Constants.typeInformationOnTriggerDetails)
                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                        .foregroundColor(Color.mainGray)
                                        .padding(Spacing.m)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )
                .onTapGesture {
                    focusedField = .triggerDetails
                }
        }
    }
    
    // MARK: - Reaction Description Field
    private var reactionDescriptionField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.reactionDescription)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextEditor(
                text: Binding(
                    get: { initialViewModel.allergyRequest.reactionDescription ?? "" },
                    set: { initialViewModel.allergyRequest.reactionDescription = $0 }
                )
            )
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .padding(Spacing.m)
                .background(Color.green50)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .triggerDetails ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .overlay(
                    Group {
                        if (initialViewModel.allergyRequest.reactionDescription ?? "").isEmpty {
                            VStack {
                                HStack {
                                    Text(Constants.typeInformationOnReactionDescription)
                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                        .foregroundColor(Color.mainGray)
                                        .padding(Spacing.m)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )
                .onTapGesture {
                    focusedField = .reactionDescription
                }
        }
    }
    
    // MARK: - Specific Instructions Field
    private var specificInstructionsField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.specificInstructions)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextEditor(
                text: Binding(
                    get: { initialViewModel.allergyRequest.specificInstructions ?? "" },
                    set: { initialViewModel.allergyRequest.specificInstructions = $0 }
                )
            )
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .padding(Spacing.m)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .triggerDetails ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .overlay(
                    Group {
                        if (initialViewModel.allergyRequest.specificInstructions ?? "").isEmpty {
                            VStack {
                                HStack {
                                    Text(Constants.exampleInstructions)
                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                        .foregroundColor(Color.mainGray)
                                        .padding(Spacing.m)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )
                .onTapGesture {
                    focusedField = .specificInstructions
                }
        }
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        Button(action: {
            // Dismiss keyboard before navigation
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
extension InitialAllergiesView {
    
    private var isFormValid: Bool {
            let name = (initialViewModel.allergyRequest.allergyName ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let trigger = (initialViewModel.allergyRequest.triggerDetails ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let reaction = (initialViewModel.allergyRequest.reactionDescription ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let instructions = (initialViewModel.allergyRequest.specificInstructions ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            return !name.isEmpty &&
                   !trigger.isEmpty &&
                   !reaction.isEmpty &&
                   !instructions.isEmpty
    }
}
