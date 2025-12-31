//
//  CreateDiapersScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 29/12/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreateDiapersScreenView: View {
    
    // MARK: - Properties
    @Environment(Router.self) private var router
    
    @State private var viewModel = CreateDiapersViewModel()
    
    @FocusState private var focusedField: Field?
    
    @State private var showTimePicker = false
    @State private var selectedTimeDate: Date = Date()
    
    // Custom Days
    @State private var showCustomDaysPicker = false
    
    // Image Upload (Max 3 photos)
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    // MARK: - Enums
    enum Field {
        case title, feedingInstructions, bottlingInstructions, customOunces
    }
    
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
        BaseHeaderView(title: Constants.diapers, onBack: {
            router.pop()
        })
    }
    
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.l) {
                nameDiapersView
                diapersScheduleView
                imageUploadView
                repeatFrequencyView
                createRoutineButton
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, Spacing.m)
        }
        .onAppear {
            // Set kidID from UserDefaults or hardcoded for testing
            viewModel.kidID = "tmD5oSt936r75qzwebQ3"
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
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
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
extension CreateDiapersScreenView {
    
    private var diapersScheduleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.diapers)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundColor(Color.black400)
            
            Text(Constants.selectInfoBelow)
                .appFont(name: .montserrat, weight: .italic, size: FontSize.title10)
                .foregroundColor(Color.yellow700)
                .padding(.top, Spacing.xxs)
            
            VStack {
                Text(Constants.typeString)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: DiapersType.allCases) { item in
                        BorderTagButton(
                            title: item.rawValue,
                            isSelected: viewModel.selectedType == item,
                            onTap: {
                                viewModel.selectedType = item
                            },
                            cornerRadius: 8
                        )
                    }
                }
                
                Text(Constants.timeString)
                    .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Spacing.m)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: viewModel.allTimes) { item in
                        BorderTagButton(
                            title: item.displayName,
                            isSelected: viewModel.selectedTime == item.displayName,
                            onTap: {
                                viewModel.selectedTime = item.displayName
                            },
                            cornerRadius: 8
                        )
                    }
                }
                
                HStack {
                    BorderTagButton(
                        title: Constants.addCustomTime,
                        isSelected: false,
                        onTap: {
                            showTimePicker = true
                        },
                        cornerRadius: 8
                    )
                    .sheet(isPresented: $showTimePicker) {
                        timePickerSheet(
                            selectedDate: $selectedTimeDate,
                            onDone: {
                                let timeString = selectedTimeDate.formatTime()
                                viewModel.addCustomTime(timeString)
                                viewModel.selectedTime = timeString
                                showTimePicker = false
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(.leading, Spacing.xxs)
                
                // Diapers Instructions notes
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(Constants.instructionsDiapers)
                        .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $viewModel.diapersInstructions)
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .padding(Spacing.xs)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focusedField == .feedingInstructions ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if viewModel.diapersInstructions.isEmpty {
                                    VStack {
                                        HStack {
                                            Text(Constants.diapersInstructionsPlaceholder)
                                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                                .foregroundColor(Color.greyText)
                                                .padding(Spacing.m)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        )
                        .focused($focusedField, equals: .feedingInstructions)
                }
                .padding(.top, Spacing.m)
            }
            .padding(Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.top, Spacing.xs)
        }
    }
    
    private var imageUploadView: some View {
        ImageUploadView(
            selectedPhotos: $selectedPhotos,
            selectedImages: $selectedImages,
            maxSelectionCount: 3,
            minSelectionCount: 1,
            placeholderText: "picture of diapers (optional)*",
            onRemove: { index in
                removeImage(at: index)
            }
        )
    }
    
    private var repeatFrequencyView: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.howOftenShouldThisRepeat)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundStyle(Color.black400)
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: viewModel.dayRepeatRoutines) { text in
                        BorderTagButton(
                            title: text,
                            isSelected: viewModel.selectedRepeatFrequency == text,
                            onTap: {
                                if text == RepeatFrequency.customDay.rawValue {
                                    showCustomDaysPicker = true
                                } else {
                                    viewModel.selectedRepeatFrequency = text
                                }
                            },
                            cornerRadius: 8
                        )
                    }
                }
            }
            .padding(Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .sheet(isPresented: $showCustomDaysPicker) {
            customDaysPickerSheet
        }
    }
    
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
}

// MARK: - Item View
extension CreateDiapersScreenView {
    
    private var nameDiapersView: some View {
        TextField(
            "",
            text: $viewModel.title,
            prompt: Text(Constants.enterRoutineTitle).foregroundColor(Color.greyText)
        )
        .textFieldStyle(.plain)
        .appFont(name: .montserrat, weight: .bold, size: FontSize.title16)
        .padding(.vertical, Spacing.s)
        .background(Color.white)
        .focused($focusedField, equals: .title)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(focusedField == .title ? Color.yellow700 : Color.borderNeutralWhite),
            alignment: .bottom
        )
    }
}

// MARK: - Helper
extension CreateDiapersScreenView {
    
    private func timePickerSheet(selectedDate: Binding<Date>, onDone: @escaping () -> Void) -> some View {
        TimePickerSheetView(selectedDate: selectedDate, onDone: onDone)
    }
    
    private var customDaysPickerSheet: some View {
        CustomDaysPickerSheetView(
            selectedDay: $viewModel.selectedRepeatFrequency,
            onDaySelected: { day in
                viewModel.selectCustomDay(day)
            },
            onDismiss: {
                showCustomDaysPicker = false
            }
        )
    }
    
    private func removeImage(at index: Int) {
        guard index < selectedImages.count && index < selectedPhotos.count else { return }
        selectedImages.remove(at: index)
        selectedPhotos.remove(at: index)
        viewModel.selectedImagesData.remove(at: index)
    }
}

#Preview {
    CreateDiapersScreenView()
}
