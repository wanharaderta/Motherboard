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
    @Environment(InitialViewModel.self) private var initialViewModel
    
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
        .alert(Constants.error, isPresented: Binding(get: { initialViewModel.isError }, set: { if !$0 { initialViewModel.clearError() } })) {
            Button(Constants.ok) {
                initialViewModel.clearError()
            }
        } message: {
            Text(initialViewModel.errorMessage ?? Constants.errorOccurred)
        }
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let newValue = newValue {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        initialViewModel.medicationImage = image
                    }
                } else {
                    selectedImage = nil
                    initialViewModel.medicationImage = nil
                }
            }
        }
    }
    
    private var headerView: some View {
        Text(Constants.medications)
            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
            .foregroundColor(Color.codGreyText)
            .padding(.top, -Spacing.s)
    }
    
    // MARK: - Medications Section
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
    
    // MARK: - Medication Name Field
    private var medicationNameField: some View {
        LabeledInputField(
            label: Constants.medicationName,
            placeholder: Constants.placeholder,
            text: Binding(get: { initialViewModel.medicationName }, set: { initialViewModel.medicationName = $0 }),
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
            selectedValue: Binding(get: { initialViewModel.dose }, set: { initialViewModel.dose = $0 }),
            field: Field.dose,
            focus: $focusedField
        )
    }
    
    // MARK: - Route Field
    private var routeField: some View {
        MenuField(
            label: Constants.route,
            selectedValue: Binding(get: { initialViewModel.route }, set: { initialViewModel.route = $0 }),
            field: Field.route,
            focus: $focusedField
        )
    }
    
    // MARK: - Frequency Field
    private var frequencyField: some View {
        MenuField(
            label: Constants.frequency,
            selectedValue: Binding(get: { initialViewModel.frequency }, set: { initialViewModel.frequency = $0 }),
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
            
            TextField(Constants.enterTimeframe, text: .constant(initialViewModel.timeSchedule.isEmpty ? "" : initialViewModel.timeSchedule))
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
                    showTimeSchedulePicker.toggle()
                }
                .sheet(isPresented: $showTimeSchedulePicker) {
                    VStack {
                        DatePicker("", selection: $selectedTimeSchedule, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            initialViewModel.timeSchedule = selectedTimeSchedule.formatDate()
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
            
            TextField(Constants.kindlyProvideInformationOnStartDate, text: .constant(initialViewModel.medicationStartDate.isEmpty ? "" : initialViewModel.medicationStartDate))
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
                    showStartDatePicker.toggle()
                }
                .sheet(isPresented: $showStartDatePicker) {
                    VStack {
                        DatePicker("", selection: $selectedStartDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            initialViewModel.medicationStartDate = selectedStartDate.formatDate()
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
            
            TextField(Constants.kindlyProvideInformationOnStartDate, text: .constant(initialViewModel.medicationEndDate.isEmpty ? "" : initialViewModel.medicationEndDate))
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
                    showEndDatePicker.toggle()
                }
                .sheet(isPresented: $showEndDatePicker) {
                    VStack {
                        DatePicker("", selection: $selectedEndDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            initialViewModel.medicationEndDate = selectedEndDate.formatDate()
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
            
            TextEditor(text: Binding(get: { initialViewModel.doctorsNote }, set: { initialViewModel.doctorsNote = $0 }))
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
                        if initialViewModel.doctorsNote.isEmpty {
                            VStack {
                                HStack {
                                    Text(Constants.provideInformationOnDoctorsNote)
                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                        .foregroundColor(Color.mineShaftOpacity86)
                                        .padding(.leading, Spacing.m + 4)
                                        .padding(.top, Spacing.m + 8)
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
extension InitialMedicationsView {
    private func handleContinue() {
        // All fields are optional for medications, so we can always continue
        onContinue?()
    }
}
