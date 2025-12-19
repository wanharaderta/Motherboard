//
//  OnboardingMedicationsView.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit

struct InitialMedicationsView: View {
    
    // MARK: - Properties
    @Environment(InitialViewModel.self) private var viewModel
    
    @FocusState private var focusedField: Field?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showTimeSchedulePicker = false
    @State private var selectedTimeSchedule: Date = Date()
    @State private var showStartDatePicker = false
    @State private var selectedStartDate: Date = Date()
    @State private var showEndDatePicker = false
    @State private var selectedEndDate: Date = Date()
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    // MARK: - Enums
    enum Field {
        case medicationName, dose, route, frequency, timeSchedule, startDate, endDate, doctorsNote
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.m) {
                headerView
                contentView
                imageUploadSection
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
        .onAppear {
            if let existingImage = viewModel.medicationRequest.medicationImage {
                selectedImage = existingImage
            }
        }
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let newValue = newValue {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        viewModel.medicationRequest.medicationImage = image
                    }
                } else {
                    selectedImage = nil
                    viewModel.medicationRequest.medicationImage = nil
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        Text(Constants.medications)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
    }
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            medicationNameField
            doseField
            routeField
            frequencyField
            timeScheduleField
            startDateField
            endDateField
            doctorsNoteField
        }
        .padding(Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Item View
extension InitialMedicationsView {
    // MARK: - Medication Name Field
    private var medicationNameField: some View {
        LabeledInputField(
            label: Constants.medicationName,
            placeholder: Constants.placeholder,
            text: Binding(
                get: { viewModel.medicationRequest.medicationName ?? "" },
                set: { viewModel.medicationRequest.medicationName = $0 }
            ),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.green50,
            field: .medicationName,
            focus: $focusedField
        )
    }
    
    // MARK: - Dose Field
    private var doseField: some View {
        MenuField(
            label: Constants.dose,
            selectedValue: Binding(
                get: { viewModel.medicationRequest.dose ?? .mgML },
                set: { viewModel.medicationRequest.dose = $0 }
            ),
            field: Field.dose,
            focus: $focusedField
        )
    }
    
    // MARK: - Route Field
    private var routeField: some View {
        MenuField(
            label: Constants.route,
            selectedValue: Binding(
                get: { viewModel.medicationRequest.route ?? .oral },
                set: { viewModel.medicationRequest.route = $0 }
            ),
            field: Field.route,
            focus: $focusedField
        )
    }
    
    // MARK: - Frequency Field
    private var frequencyField: some View {
        MenuField(
            label: Constants.frequency,
            selectedValue: Binding(
                get: { viewModel.medicationRequest.frequency ?? .daily },
                set: { viewModel.medicationRequest.frequency = $0 }
            ),
            field: Field.frequency,
            focus: $focusedField
        )
    }
    
    // MARK: - Time Schedule Field
    private var timeScheduleField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.timeSchedule)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.black300)
            
            TextField(Constants.enterTimeframe, text: .constant((viewModel.medicationRequest.timeSchedule ?? "").isEmpty ? "" : (viewModel.medicationRequest.timeSchedule ?? "")))
                .textFieldStyle(.plain)
                .disabled(true)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .timeSchedule ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .onTapGesture {
                    focusedField = .timeSchedule
                    if let dateString = viewModel.medicationRequest.timeSchedule, !dateString.isEmpty {
                        selectedTimeSchedule = Date.parseDate(from: dateString) ?? Date()
                    }
                    showTimeSchedulePicker.toggle()
                }
                .sheet(isPresented: $showTimeSchedulePicker) {
                    VStack {
                        DatePicker("", selection: $selectedTimeSchedule, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            viewModel.medicationRequest.timeSchedule = selectedTimeSchedule.formatDate()
                            showTimeSchedulePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium])
                }
        }
    }
    
    // MARK: - Start Date Field
    private var startDateField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.startDate)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextField(Constants.kindlyProvideInformationOnStartDate, text: .constant((viewModel.medicationRequest.medicationStartDate ?? "").isEmpty ? "" : (viewModel.medicationRequest.medicationStartDate ?? "")))
                .textFieldStyle(.plain)
                .disabled(true)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .startDate ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .onTapGesture {
                    focusedField = .startDate
                    if let dateString = viewModel.medicationRequest.medicationStartDate, !dateString.isEmpty {
                        selectedStartDate = Date.parseDate(from: dateString) ?? Date()
                    }
                    showStartDatePicker.toggle()
                }
                .sheet(isPresented: $showStartDatePicker) {
                    VStack {
                        DatePicker("", selection: $selectedStartDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            viewModel.medicationRequest.medicationStartDate = selectedStartDate.formatDate()
                            showStartDatePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium])
                }
        }
    }
    
    // MARK: - End Date Field
    private var endDateField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.endDateOptional)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextField(Constants.kindlyProvideInformationOnStartDate, text: .constant((viewModel.medicationRequest.medicationEndDate ?? "").isEmpty ? "" : (viewModel.medicationRequest.medicationEndDate ?? "")))
                .textFieldStyle(.plain)
                .disabled(true)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .endDate ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .onTapGesture {
                    focusedField = .endDate
                    if let dateString = viewModel.medicationRequest.medicationEndDate, !dateString.isEmpty {
                        selectedEndDate = Date.parseDate(from: dateString) ?? Date()
                    }
                    showEndDatePicker.toggle()
                }
                .sheet(isPresented: $showEndDatePicker) {
                    VStack {
                        DatePicker("", selection: $selectedEndDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            viewModel.medicationRequest.medicationEndDate = selectedEndDate.formatDate()
                            showEndDatePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium])
                }
        }
    }
    
    // MARK: - Doctors Note Field
    private var doctorsNoteField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.doctorsNote)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            TextEditor(text: Binding(
                get: { viewModel.medicationRequest.doctorsNote ?? "" },
                set: { viewModel.medicationRequest.doctorsNote = $0 }
            ))
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .doctorsNote ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
                .overlay(
                    Group {
                        if (viewModel.medicationRequest.doctorsNote ?? "").isEmpty {
                            VStack {
                                HStack {
                                    Text(Constants.provideInformationOnDoctorsNote)
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
                    focusedField = .doctorsNote
                }
        }
    }
    
    // MARK: - Image Upload Section
    private var imageUploadSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            if let image = selectedImage {
                VStack(spacing: Spacing.m) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 170)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button(action: {
                        selectedPhoto = nil
                        selectedImage = nil
                    }) {
                        Text(Constants.removePhoto)
                            .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                            .foregroundColor(.red)
                    }
                }
            } else {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    VStack(spacing: Spacing.xs) {
                        Image("icAttachedImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.pampas)
                        
                        VStack(spacing: 2) {
                            HStack(spacing: 0) {
                                Text(Constants.please)
                                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                    .foregroundColor(Color.black200)
                                
                                Text(Constants.tapToUpload)
                                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title12)
                                    .foregroundColor(Color.black300)
                            }
                            
                            Text(Constants.pictureOfMedicationBottle)
                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                .foregroundColor(Color.black200)
                        }
                        .padding(.top, Spacing.xxs)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color.green200)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
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
extension InitialMedicationsView {
    
    private var isFormValid: Bool {
        let medicationName = (viewModel.medicationRequest.medicationName ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !medicationName.isEmpty
    }
}
