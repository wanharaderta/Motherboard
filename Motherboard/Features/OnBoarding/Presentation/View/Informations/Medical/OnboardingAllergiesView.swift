////
////  AllergiesHealthMedicalView.swift
////  Motherboard
////
////  Created by Wanhar on 14/12/25.
////
//
//import Foundation
//import SwiftUI
//
//struct AllergiesHealthMedicalView: View {
//    
//    // MARK: - Properties
//    
//    var onContinue: (() -> Void)?
//    var onSkip: (() -> Void)?
//    
//    @State var viewModel = HealthMedicalInfoViewModel()
//    @FocusState private var focusedField: Field?
//    
//    // MARK: - Enums
//    enum Field {
//        case allergyName, severity, triggerDetails, reactionDescription, specificInstructions
//    }
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            VStack(alignment: .leading, spacing: Spacing.m) {
//                contentView
//                continueButton
//                
//                Spacer()
//                    .frame(height: Spacing.xl)
//            }
//            .padding([.top, .horizontal], Spacing.xl)
//        }
//        .background(Color.white.ignoresSafeArea())
//        .alert(Constants.error, isPresented: $viewModel.isError) {
//            Button(Constants.ok) {
//                viewModel.clearError()
//            }
//        } message: {
//            Text(viewModel.errorMessage ?? Constants.errorOccurred)
//        }
//    }
//    
//    // MARK: - Allergies Section
//    private var contentView: some View {
//        VStack(alignment: .leading, spacing: Spacing.l) {
//            Text(Constants.allergies)
//                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
//                .foregroundColor(Color.codGreyText)
//            
//            allergyNameField
//            severityField
//            triggerDetailsField
//            reactionDescriptionField
//            specificInstructionsField
//        }
//        .padding(Spacing.m)
//        .background(Color.green50)
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//    }
//    
//    // MARK: - Allergy Name Field
//    private var allergyNameField: some View {
//        LabeledInputField(
//            label: Constants.allergyName,
//            placeholder: Constants.placeholder,
//            text: $viewModel.allergyName,
//            bgPlaceholderColor: Color.green50,
//            field: .allergyName,
//            focus: $focusedField,
//        )
//    }
//    
//    // MARK: - Severity Field
//    private var severityField: some View {
//        VStack(alignment: .leading, spacing: Spacing.xs) {
//            Text(Constants.severity)
//                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                .foregroundColor(Color.mineShaftOpacity86)
//            
//            Menu {
//                ForEach(AllergySeverity.allCases, id: \.self) { severityOption in
//                    Button(action: {
//                        viewModel.severity = severityOption
//                    }) {
//                        HStack {
//                            Text(severityOption.displayName)
//                            if viewModel.severity == severityOption {
//                                Image(systemName: "checkmark")
//                            }
//                        }
//                    }
//                }
//            } label: {
//                HStack {
//                    Text(viewModel.severity.displayName)
//                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                        .foregroundColor(Color.tundora)
//                    Spacer()
//                    Image(systemName: "chevron.down")
//                        .foregroundColor(Color.tundora)
//                        .font(.system(size: 12, weight: .medium))
//                }
//                .padding(Spacing.m)
//                .background(Color.green50)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(focusedField == .severity ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
//                )
//            }
//            .onTapGesture {
//                focusedField = .severity
//            }
//        }
//    }
//    
//    // MARK: - Trigger Details Field
//    private var triggerDetailsField: some View {
//        VStack(alignment: .leading, spacing: Spacing.xs) {
//            Text(Constants.triggerDetails)
//                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                .foregroundColor(Color.mineShaftOpacity86)
//            
//            TextEditor(text: $viewModel.triggerDetails)
//                .frame(minHeight: 100)
//                .scrollContentBackground(.hidden)
//                .padding(Spacing.m)
//                .background(Color.green50)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green200, lineWidth: 1))
//                .overlay(
//                    Group {
//                        if viewModel.triggerDetails.isEmpty {
//                            VStack {
//                                HStack {
//                                    Text(Constants.typeInformationOnTriggerDetails)
//                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                                        .foregroundColor(Color.mineShaftOpacity86)
//                                        .padding(Spacing.m)
//                                    Spacer()
//                                }
//                                Spacer()
//                            }
//                        }
//                    }
//                )
//                .onTapGesture {
//                    focusedField = .triggerDetails
//                }
//        }
//    }
//    
//    // MARK: - Reaction Description Field
//    private var reactionDescriptionField: some View {
//        VStack(alignment: .leading, spacing: Spacing.xs) {
//            Text(Constants.reactionDescription)
//                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                .foregroundColor(Color.mineShaftOpacity86)
//            
//            TextEditor(text: $viewModel.reactionDescription)
//                .frame(minHeight: 100)
//                .padding(Spacing.m)
//                .background(Color.green50)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(focusedField == .reactionDescription ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
//                )
//                .overlay(
//                    Group {
//                        if viewModel.reactionDescription.isEmpty {
//                            VStack {
//                                HStack {
//                                    Text(Constants.typeInformationOnReactionDescription)
//                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                                        .foregroundColor(Color.mineShaftOpacity86)
//                                        .padding(.leading, Spacing.m + 4)
//                                        .padding(.top, Spacing.m + 8)
//                                    Spacer()
//                                }
//                                Spacer()
//                            }
//                        }
//                    }
//                )
//                .onTapGesture {
//                    focusedField = .reactionDescription
//                }
//        }
//    }
//    
//    // MARK: - Specific Instructions Field
//    private var specificInstructionsField: some View {
//        VStack(alignment: .leading, spacing: Spacing.xs) {
//            Text(Constants.specificInstructions)
//                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                .foregroundColor(Color.mineShaftOpacity86)
//            
//            TextEditor(text: $viewModel.specificInstructions)
//                .frame(minHeight: 100)
//                .padding(Spacing.m)
//                .background(Color.green50)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(focusedField == .specificInstructions ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
//                )
//                .overlay(
//                    Group {
//                        if viewModel.specificInstructions.isEmpty {
//                            VStack {
//                                HStack {
//                                    Text(Constants.exampleInstructions)
//                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                                        .foregroundColor(Color.mineShaftOpacity86)
//                                        .padding(.leading, Spacing.m + 4)
//                                        .padding(.top, Spacing.m + 8)
//                                    Spacer()
//                                }
//                                Spacer()
//                            }
//                        }
//                    }
//                )
//                .onTapGesture {
//                    focusedField = .specificInstructions
//                }
//        }
//    }
//    
//    // MARK: - Continue Button
//    private var continueButton: some View {
//        Button(action: {
//            handleContinue()
//        }) {
//            Text(Constants.continueString)
//                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
//                .foregroundColor(Color.green500)
//                .frame(maxWidth: .infinity)
//                .frame(height: 50)
//                .background(Color.white)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.green500, lineWidth: 1)
//                )
//        }
//        .padding(.vertical, Spacing.xl)
//    }
//    
//}
//
//// MARK: - Helper Methods
//extension AllergiesHealthMedicalView {
//    private func handleContinue() {
//        guard viewModel.validateForm() else {
//            return
//        }
//        
//        // Handle continue action
//        onContinue?()
//    }
//}
