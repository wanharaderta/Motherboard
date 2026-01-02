//
//  CreateMedicationsScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 31/12/25.
//

import SwiftUI
import PhotosUI

struct CreateMedicationsScreenView: View {
    
    // MARK: - Properties
    @Environment(Router.self) private var router
    
    @State private var viewModel = CreateMedicationsViewModel()
    
    @FocusState private var focusedField: LabelField?
    
    @State private var selectedTimeInterval: TimeInterval? = nil
    @State private var showStartDatePicker = false
    @State private var selectedStartDate: Date = Date()
    @State private var showEndDatePicker = false
    @State private var selectedEndDate: Date = Date()
    @State private var selectedRepeatFrequency: RepeatFrequency = .everyDay
    
    // Custom Days
    @State private var showCustomDaysPicker = false
    
    // Image Upload (Max 3 photos)
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                contentView
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Header
    private var headerView: some View {
        BaseHeaderView(title: Constants.medications, onBack: {
            router.pop()
        })
    }
    
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.l) {
                medicationFormSection
                imageUploadView
                createRoutineButton
            }
            .padding(.top, Spacing.m)
            .padding(.horizontal, Spacing.xl)
        }
        .onAppear {
            // Set kidID from UserDefaults or hardcoded for testing
            viewModel.kidID = "tmD5oSt936r75qzwebQ3"
            
            // Initialize selectedTimeInterval from intervalHour
            if let intervalHour = viewModel.medicationRequest.intervalHour {
                selectedTimeInterval = TimeInterval.allCases.first { $0.code == intervalHour }
            }
        }
        .onChange(of: selectedPhotos) { oldValue, newValue in
            Task {
                selectedImages.removeAll()
                viewModel.selectedImagesData.removeAll()
                viewModel.selectedImages.removeAll()
                
                // Limit to maximum 3 photos
                let limitedPhotos = Array(newValue.prefix(3))
                
                for photo in limitedPhotos {
                    if let data = try? await photo.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImages.append(image)
                            viewModel.selectedImagesData.append(data)
                            viewModel.selectedImages.append(image)
                        }
                    }
                }
                
                // Update selectedPhotos if limited
                if newValue.count > 3 {
                    selectedPhotos = limitedPhotos
                }
            }
        }
        .onChange(of: viewModel.isSuccess) { _, isSuccess in
            if isSuccess {
                router.push(to: RoutinesRoute.successRoutine)
            }
        }
        .alert(Constants.errorString, isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(Constants.okString.uppercased()) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - Sub View
extension CreateMedicationsScreenView {
    
    // MARK: - Medication Form Section
    private var medicationFormSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.addMedicationRoutine)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundColor(Color.black400)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(Constants.addMedicationMessage)
                .appFont(name: .montserrat, weight: .italic, size: FontSize.title10)
                .foregroundColor(Color.yellow700)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
            field: .dose,
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
            field: .route,
            focus: $focusedField
        )
    }
    
    // MARK: - Frequency Field
    private var frequencyField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.frequency)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.black300)
            
            Menu {
                ForEach(RepeatFrequency.allCases.filter { $0 != .customDay }, id: \.self) { frequency in
                    Button(action: {
                        selectedRepeatFrequency = frequency
                        viewModel.selectedRepeatFrequency = frequency.rawValue
                        // Map RepeatFrequency to MedicationFrequency for backward compatibility
                        switch frequency {
                        case .everyDay:
                            viewModel.medicationRequest.frequency = .daily
                        case .weekdaysOnly, .weekendsOnly:
                            viewModel.medicationRequest.frequency = .daily
                        case .customDay:
                            break
                        }
                    }) {
                        HStack {
                            Text(frequency.displayName)
                            if selectedRepeatFrequency == frequency {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedRepeatFrequency.displayName)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.mineShaft)
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .frequency ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
            }
            .onTapGesture {
                focusedField = .frequency
            }
        }
    }
    
    // MARK: - Time Schedule Field
    private var timeScheduleField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.timeSchedule)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.black300)
            
            Menu {
                ForEach(TimeInterval.allCases, id: \.self) { interval in
                    Button(action: {
                        selectedTimeInterval = interval
                        viewModel.medicationRequest.intervalHour = interval.code
                    }) {
                        HStack {
                            Text(interval.displayName)
                            if selectedTimeInterval == interval {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedTimeInterval?.displayName ?? Constants.enterTimeframe)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .foregroundColor(selectedTimeInterval == nil ? Color.mainGray : Color.black300)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.mineShaft)
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(Spacing.m)
                .background(Color.green50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .timeSchedule ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
            }
            .onTapGesture {
                focusedField = .timeSchedule
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
                    if let dateTimeString = viewModel.medicationRequest.medicationStartDate, !dateTimeString.isEmpty {
                        selectedStartDate = Date.parseDateAndTime(from: dateTimeString) ?? Date.parseDate(from: dateTimeString) ?? Date()
                    }
                    showStartDatePicker.toggle()
                }
                .sheet(isPresented: $showStartDatePicker) {
                    VStack {
                        DatePicker("", selection: $selectedStartDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            viewModel.medicationRequest.medicationStartDate = selectedStartDate.formatDateAndTime()
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
                    if let dateTimeString = viewModel.medicationRequest.medicationEndDate, !dateTimeString.isEmpty {
                        selectedEndDate = Date.parseDateAndTime(from: dateTimeString) ?? Date.parseDate(from: dateTimeString) ?? Date()
                    }
                    showEndDatePicker.toggle()
                }
                .sheet(isPresented: $showEndDatePicker) {
                    VStack {
                        DatePicker("", selection: $selectedEndDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button(Constants.done) {
                            viewModel.medicationRequest.medicationEndDate = selectedEndDate.formatDateAndTime()
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
    
    private var imageUploadView: some View {
        ImageUploadView(
            selectedPhotos: $selectedPhotos,
            selectedImages: $selectedImages,
            maxSelectionCount: 3,
            minSelectionCount: 1,
            placeholderText: "picture of medications (optional)*",
            onRemove: { index in
                removeImage(at: index)
            }
        )
    }
}

// MARK: - Helpers
extension CreateMedicationsScreenView {
    private var createRoutineButton: some View {
        Button(action: {
            focusedField = nil
            Task {
                await viewModel.createRoutine()
            }
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: viewModel.isFormValid ? .white : .green))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            } else {
                Text(Constants.createRoutine)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(viewModel.isFormValid ? Color.white : Color.green500)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
        }
        .background(viewModel.isFormValid ? Color.primaryGreen900 : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    viewModel.isFormValid ? Color.white : Color.green500,
                    lineWidth: 1
                )
        )
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .padding(.vertical, Spacing.xl)
    }
    
    private func removeImage(at index: Int) {
        guard index < selectedImages.count && index < selectedPhotos.count else { return }
        selectedImages.remove(at: index)
        selectedPhotos.remove(at: index)
        viewModel.selectedImagesData.remove(at: index)
    }
}

#Preview {
    CreateMedicationsScreenView()
}
