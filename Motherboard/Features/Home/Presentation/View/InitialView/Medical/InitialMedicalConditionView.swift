//
//  OnboardingMedicalConditionView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI

struct InitialMedicalConditionView: View {
    
    // MARK: - Properties
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    @Environment(InitialViewModel.self) private var viewModel
    @FocusState private var focusedField: Field?
    @State private var showDatePicker = false
    
    // MARK: - Enums
    
    enum Field {
        case conditionName
        case description
        case doctorsInstructions
        case startDate
        case ongoing
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
    
    // MARK: - Header
    private var headerView: some View {
        Text(Constants.medicalConditions)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
    }
    
    // MARK: - Content
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            conditionNameField
            descriptionField
            doctorsInstructionsField
            startDateField
            ongoingField
        }
        .padding(Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
}


// MARK: - Item View

extension InitialMedicalConditionView {
    
    // MARK: Condition Name Field
    
    private var conditionNameField: some View {
        LabeledInputField(
            label: Constants.conditionName,
            placeholder: Constants.placeholder,
            text: Binding(
                get: { viewModel.medicalConditionRequest.conditionName ?? "" },
                set: { viewModel.medicalConditionRequest.conditionName = $0 }
            ),
            labelColor: Color.black300,
            textPlaceholderColor: Color.mainGray,
            bgPlaceholderColor: Color.green50,
            field: .conditionName,
            focus: $focusedField
        )
    }
    
    // MARK: Description Field
    
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            fieldLabel(Constants.description)
            
            TextEditor(text: Binding(
                get: { viewModel.medicalConditionRequest.conditionDescription ?? "" },
                set: { viewModel.medicalConditionRequest.conditionDescription = $0 }
            ))
            .frame(minHeight: 100)
            .scrollContentBackground(.hidden)
            .padding(Spacing.m)
            .background(Color.green50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        focusedField == .description ? Color.green200 : Color.borderNeutralWhite,
                        lineWidth: 1
                    )
            )
            .overlay(placeholderOverlay(
                text: Constants.giveMoreInformationOnConditionDescription,
                isEmpty: (viewModel.medicalConditionRequest.conditionDescription ?? "").isEmpty
            ))
            .onTapGesture {
                focusedField = .description
            }
        }
    }
    
    // MARK: Doctors Instructions Field
    
    private var doctorsInstructionsField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            fieldLabel(Constants.doctorsInstructions)
            
            TextEditor(text: Binding(
                get: { viewModel.medicalConditionRequest.doctorsInstructions ?? "" },
                set: { viewModel.medicalConditionRequest.doctorsInstructions = $0 }
            ))
            .frame(minHeight: 100)
            .scrollContentBackground(.hidden)
            .padding(Spacing.m)
            .background(Color.green50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        focusedField == .doctorsInstructions ? Color.green200 : Color.borderNeutralWhite,
                        lineWidth: 1
                    )
            )
            .overlay(placeholderOverlay(
                text: Constants.provideInformationOnDoctorsInstructions,
                isEmpty: (viewModel.medicalConditionRequest.doctorsInstructions ?? "").isEmpty,
                customPadding: true
            ))
            .onTapGesture {
                focusedField = .doctorsInstructions
            }
        }
    }
    
    // MARK: Start Date Field
    
    private var startDateField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            fieldLabel(Constants.startDate)
            
            HStack(spacing: 0) {
                TextField(
                    Constants.enterConditionsStartDate,
                    text: .constant((viewModel.medicalConditionRequest.startDate ?? Date()).formatDate())
                )
                .textFieldStyle(.plain)
                .disabled(true)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .padding(Spacing.m)
                
                calendarButton {
                    showDatePicker.toggle()
                }
            }
            .background(Color.green50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        focusedField == .startDate ? Color.green200 : Color.borderNeutralWhite,
                        lineWidth: 1
                    )
            )
            .onTapGesture {
                focusedField = .startDate
                showDatePicker.toggle()
            }
            .sheet(isPresented: $showDatePicker) {
                datePickerSheet
            }
        }
    }
    
    // MARK: Ongoing Field
    
    private var ongoingField: some View {
        MenuField(
            label: Constants.ongoing,
            selectedValue: Binding(
                get: { viewModel.medicalConditionRequest.ongoing ?? .yes },
                set: { viewModel.medicalConditionRequest.ongoing = $0 }
            ),
            field: Field.ongoing,
            focus: $focusedField,
            labelColor: Color.mineShaftOpacity86,
            backgroundColor: Color.green50
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

// MARK: - Helper Views

extension InitialMedicalConditionView {
    
    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
            .foregroundColor(Color.mineShaftOpacity86)
    }
    
    private func placeholderOverlay(
        text: String,
        isEmpty: Bool,
        customPadding: Bool = false
    ) -> some View {
        Group {
            if isEmpty {
                VStack {
                    HStack {
                        Text(text)
                            .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                            .foregroundColor(Color.mainGray)
                            .padding(.leading, customPadding ? Spacing.m + 4 : Spacing.m)
                            .padding(.top, customPadding ? Spacing.m + 8 : Spacing.m)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func calendarButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image("icCalendar")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .frame(width: 40)
        .padding(.trailing, Spacing.xs)
    }
    
    private var datePickerSheet: some View {
        VStack {
            DatePicker("", selection: Binding(
                get: { viewModel.medicalConditionRequest.startDate ?? Date() },
                set: { viewModel.medicalConditionRequest.startDate = $0 }
            ), displayedComponents: .date)
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
            
            Button(Constants.done) {
                showDatePicker = false
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Helper Methods

extension InitialMedicalConditionView {
    
    private var isFormValid: Bool {
        let conditionName = (viewModel.medicalConditionRequest.conditionName ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let conditionDescription = (viewModel.medicalConditionRequest.conditionDescription ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let doctorsInstructions = (viewModel.medicalConditionRequest.doctorsInstructions ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !conditionName.isEmpty &&
        !conditionDescription.isEmpty &&
        !doctorsInstructions.isEmpty
    }
}
