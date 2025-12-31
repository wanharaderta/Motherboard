//
//  BreastfeedingPumpingScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 31/12/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct BreastfeedingScreenView: View {
    
    // MARK: - Properties
    @Environment(Router.self) private var router
    
    @State private var viewModel = CreateBreastViewModel()
    
    @FocusState private var focusedField: LabelField?
    
    @State private var showTimePicker = false
    @State private var selectedTimeDate: Date = Date()
    
    @State private var showPumpingTimePicker = false
    @State private var selectedPumpingTimeDate: Date = Date()
    
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
        BaseHeaderView(
            title: Constants.breastfeedingAndPumping,
            fontSize: FontSize.title20,
            onBack: {
                router.pop()
            })
    }
    
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.l) {
                breastScheduleView
                pumpingScheduleView
                imageUploadView
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
extension BreastfeedingScreenView {
    
    private var breastScheduleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.breastfeedingSchedule)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundColor(Color.black400)
            
            Text(Constants.selectInfoBelow)
                .appFont(name: .montserrat, weight: .italic, size: FontSize.title10)
                .foregroundColor(Color.yellow700)
                .padding(.top, Spacing.xxs)
            
            VStack {
                Text(Constants.breast)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: BreastType.allCases) { item in
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
                
                Text(Constants.breastFeedingTime)
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
                
                // Breast Instructions notes
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(Constants.instructionsBreast)
                        .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $viewModel.breastInstructions)
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
                                if viewModel.breastInstructions.isEmpty {
                                    VStack {
                                        HStack {
                                            Text(Constants.breastInstructionsPlaceholder)
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
    
    private var pumpingScheduleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.pumpingSchedule)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundColor(Color.black400)
            
            Text(Constants.selectInfoBelow)
                .appFont(name: .montserrat, weight: .italic, size: FontSize.title10)
                .foregroundColor(Color.yellow700)
                .padding(.top, Spacing.xxs)
            
            VStack {
                Text(Constants.pumping)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: BreastType.allCases) { item in
                        BorderTagButton(
                            title: item.rawValue,
                            isSelected: viewModel.selectedPumpingType == item,
                            onTap: {
                                viewModel.selectedPumpingType = item
                            },
                            cornerRadius: 8
                        )
                    }
                }
                
                Text(Constants.pumpingTime)
                    .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Spacing.m)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: viewModel.allPumpingTimes) { item in
                        BorderTagButton(
                            title: item.displayName,
                            isSelected: viewModel.selectedPumpingTime == item.displayName,
                            onTap: {
                                viewModel.selectedPumpingTime = item.displayName
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
                            showPumpingTimePicker = true
                        },
                        cornerRadius: 8
                    )
                    .sheet(isPresented: $showPumpingTimePicker) {
                        timePickerSheet(
                            selectedDate: $selectedPumpingTimeDate,
                            onDone: {
                                let timeString = selectedPumpingTimeDate.formatTime()
                                viewModel.addCustomPumpingTime(timeString)
                                viewModel.selectedPumpingTime = timeString
                                showPumpingTimePicker = false
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(.leading, Spacing.xxs)
                
                // Pumping Instructions notes
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(Constants.pumpingInstructionsNotes)
                        .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $viewModel.pumpingInstructions)
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
                                if viewModel.pumpingInstructions.isEmpty {
                                    VStack {
                                        HStack {
                                            Text(Constants.pumpingInstructionsPlaceholder)
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
            placeholderText: "picture of breastfeeding & pumping (optional)*",
            onRemove: { index in
                removeImage(at: index)
            }
        )
    }
}

// MARK: - Helper
extension BreastfeedingScreenView {
    
    private func timePickerSheet(selectedDate: Binding<Date>, onDone: @escaping () -> Void) -> some View {
        TimePickerSheetView(selectedDate: selectedDate, onDone: onDone)
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
    
    private func removeImage(at index: Int) {
        guard index < selectedImages.count && index < selectedPhotos.count else { return }
        selectedImages.remove(at: index)
        selectedPhotos.remove(at: index)
        viewModel.selectedImagesData.remove(at: index)
    }
}

#Preview {
    BreastfeedingScreenView()
}

