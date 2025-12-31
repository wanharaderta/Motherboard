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
    
    @Environment(InitialViewModel.self) private var viewModel
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
        .alert(Constants.error, isPresented: Binding(get: { viewModel.isError }, set: { if !$0 { viewModel.clearError() } })) {
            Button(Constants.ok) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? Constants.errorOccurred)
        }
    }
    
    private var headerView: some View {
        Text(Constants.allergies)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
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
                get: { viewModel.allergyRequest.allergyName ?? "" },
                set: { viewModel.allergyRequest.allergyName = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
            bgPlaceholderColor: Color.green50,
            field: .allergyName,
            focus: $focusedField,
        )
    }
    
    // MARK: - Severity Field
    private var severityField: some View {
        MenuField(
            label: Constants.severity,
            selectedValue: Binding(
                get: { viewModel.allergyRequest.severity ?? .mild },
                set: { viewModel.allergyRequest.severity = $0 }
            ),
            field: Field.severity,
            focus: $focusedField,
            labelColor: Color.mineShaftOpacity86,
            backgroundColor: Color.green50
        )
    }
    
    // MARK: - Trigger Details Field
    private var triggerDetailsField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.triggerDetails)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextEditor(
                text: Binding(
                    get: { viewModel.allergyRequest.triggerDetails ?? "" },
                    set: { viewModel.allergyRequest.triggerDetails = $0 }
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
                    if (viewModel.allergyRequest.triggerDetails ?? "").isEmpty {
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
                    get: { viewModel.allergyRequest.reactionDescription ?? "" },
                    set: { viewModel.allergyRequest.reactionDescription = $0 }
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
                    if (viewModel.allergyRequest.reactionDescription ?? "").isEmpty {
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
                    get: { viewModel.allergyRequest.specificInstructions ?? "" },
                    set: { viewModel.allergyRequest.specificInstructions = $0 }
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
                    if (viewModel.allergyRequest.specificInstructions ?? "").isEmpty {
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
        let name = (viewModel.allergyRequest.allergyName ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let trigger = (viewModel.allergyRequest.triggerDetails ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let reaction = (viewModel.allergyRequest.reactionDescription ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let instructions = (viewModel.allergyRequest.specificInstructions ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !name.isEmpty &&
        !trigger.isEmpty &&
        !reaction.isEmpty &&
        !instructions.isEmpty
    }
}
