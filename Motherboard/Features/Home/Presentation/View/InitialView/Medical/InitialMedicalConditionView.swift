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
    
    @Environment(InitialViewModel.self) private var initialViewModel
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
}

// MARK: - Header Views

extension InitialMedicalConditionView {
    
    private var headerView: some View {
        Text(Constants.medicalConditions)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
    }
}

// MARK: - Content Views

extension InitialMedicalConditionView {
    
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

// MARK: - Form Fields

extension InitialMedicalConditionView {
    
    // MARK: Condition Name Field
    
    private var conditionNameField: some View {
        LabeledInputField(
            label: Constants.conditionName,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.conditionName }, set: { initialViewModel.conditionName = $0 }),
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
            
            TextEditor(text: Binding(get: { initialViewModel.conditionDescription }, set: { initialViewModel.conditionDescription = $0 }))
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green200, lineWidth: 1)
                )
                .overlay(placeholderOverlay(
                    text: Constants.giveMoreInformationOnConditionDescription,
                    isEmpty: initialViewModel.conditionDescription.isEmpty
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
            
            TextEditor(text: Binding(get: { initialViewModel.doctorsInstructions }, set: { initialViewModel.doctorsInstructions = $0 }))
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
                    isEmpty: initialViewModel.doctorsInstructions.isEmpty,
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
                    text: .constant(initialViewModel.startDate.formatDate())
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
        VStack(alignment: .leading, spacing: Spacing.xs) {
            fieldLabel(Constants.ongoing)
            
            Menu {
                ForEach(Ongoing.allCases, id: \.self) { ongoingOption in
                    Button(action: {
                        initialViewModel.ongoing = ongoingOption
                    }) {
                        HStack {
                            Text(ongoingOption.displayName)
                            if initialViewModel.ongoing == ongoingOption {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                menuLabel(
                    text: initialViewModel.ongoing.displayName,
                    isFocused: focusedField == .ongoing
                )
            }
            .onTapGesture {
                focusedField = .ongoing
            }
        }
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
    
    private func menuLabel(text: String, isFocused: Bool) -> some View {
        HStack {
            Text(text)
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
                .stroke(isFocused ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
        )
    }
    
    private var datePickerSheet: some View {
        VStack {
            DatePicker("", selection: Binding(get: { initialViewModel.startDate }, set: { initialViewModel.startDate = $0 }), displayedComponents: .date)
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

// MARK: - Action Buttons

extension InitialMedicalConditionView {
    
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

extension InitialMedicalConditionView {
    
    private func handleContinue() {
        // All fields are optional for medical condition, so we can always continue
        onContinue?()
    }
}
