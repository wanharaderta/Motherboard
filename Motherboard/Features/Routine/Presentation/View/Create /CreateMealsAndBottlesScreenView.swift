//
//  CreateMealsAndBottlesScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 23/12/25.
//

import SwiftUI
import PhotosUI

struct CreateMealsAndBottlesScreenView: View {
    
    // MARK: - Properties
   // @Environment(\.dismiss) private var dismiss
    @Environment(Router.self) private var router
    
    @State private var viewModel = CreateMealAndBottlesViewModel()
    
    @FocusState private var focusedField: CreateMealAndBottlesViewModel.Field?
    
    // Meal Schedule
    @State private var showMealTimePicker = false
    @State private var selectedMealTimeDate: Date = Date()
    
    // Bottle Schedule
    @State private var showBottleTimePicker = false
    @State private var selectedBottleTimeDate: Date = Date()
    
    // Custom Ounces
    @State private var showCustomOuncesPicker = false
    @State private var customOuncesInput: String = ""
    
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
        BaseHeaderView(title: "Meals & Bottles", onBack: {
            router.pop()
        })
    }
    
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.l) {
                nameRoutineView
                mealScheduleView
                bottleScheduleView
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

// MARK: - Item View
extension CreateMealsAndBottlesScreenView {
    
    private var nameRoutineView: some View {
        TextField(
            "",
            text: $viewModel.routineTitle,
            prompt: Text(Constants.enterRoutineTitle).foregroundColor(Color.greyText)
        )
        .textFieldStyle(.plain)
        .appFont(name: .montserrat, weight: .bold, size: FontSize.title16)
        .padding(.vertical, Spacing.s)
        .background(Color.white)
        .focused($focusedField, equals: .routineTitle)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(focusedField == .routineTitle ? Color.yellow700 : Color.borderNeutralWhite),
            alignment: .bottom
        )
    }
    
    private var imageUploadView: some View {
        ImageUploadView(
            selectedPhotos: $selectedPhotos,
            selectedImages: $selectedImages,
            maxSelectionCount: 3,
            minSelectionCount: 1,
            placeholderText: "picture of meals & bottle (optional)*",
            onRemove: { index in
                removeImage(at: index)
            }
        )
    }
    
    private func removeImage(at index: Int) {
        guard index < selectedImages.count && index < selectedPhotos.count else { return }
        selectedImages.remove(at: index)
        selectedPhotos.remove(at: index)
        viewModel.selectedImagesData.remove(at: index)
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
        //.disabled(!viewModel.isFormValid || viewModel.isLoading)
        .padding(.vertical, Spacing.xl)
    }
    
}

// MARK: - Sub View
extension CreateMealsAndBottlesScreenView {
    
    private var mealScheduleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.mealSchedule)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundColor(Color.black400)
            
            Text(Constants.selectInfoBelow)
                .appFont(name: .montserrat, weight: .italic, size: FontSize.title10)
                .foregroundColor(Color.yellow700)
                .padding(.top, Spacing.xxs)
            
            VStack {
                Text(Constants.mealName)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: MealName.allCases) { item in
                        BorderTagButton(
                            title: item.rawValue,
                            isSelected: viewModel.selectedMealName == item,
                            onTap: {
                                viewModel.selectedMealName = item
                            },
                            cornerRadius: 8
                        )
                    }
                }
                
                Text(Constants.mealTime)
                    .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Spacing.m)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: viewModel.allMealTimes) { item in
                        BorderTagButton(
                            title: item.displayName,
                            isSelected: viewModel.selectedMealTime == item.displayName,
                            onTap: {
                                viewModel.selectedMealTime = item.displayName
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
                            showMealTimePicker = true
                        },
                        cornerRadius: 8
                    )
                    .sheet(isPresented: $showMealTimePicker) {
                        timePickerSheet(
                            selectedDate: $selectedMealTimeDate,
                            onDone: {
                                let timeString = selectedMealTimeDate.formatTime()
                                viewModel.addCustomMealTime(timeString)
                                viewModel.selectedMealTime = timeString
                                showMealTimePicker = false
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(.leading, Spacing.xxs)
                
                // Feeding Instructions Notes
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(Constants.feedingInstructionsNotes)
                        .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $viewModel.feedingInstructions)
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
                                if viewModel.feedingInstructions.isEmpty {
                                    VStack {
                                        HStack {
                                            Text(Constants.feedingInstructionsPlaceholder)
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
    
    private var bottleScheduleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.bottleSchedule)
                .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                .foregroundColor(Color.black400)
            
            Text(Constants.selectInfoBelow)
                .appFont(name: .montserrat, weight: .italic, size: FontSize.title10)
                .foregroundColor(Color.yellow700)
                .padding(.top, Spacing.xxs)
            
            VStack {
                Text(Constants.bottlingTime)
                    .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: Spacing.s) {
                    TagCloudView(data: viewModel.allBottleTimes) { item in
                        BorderTagButton(
                            title: item.displayName,
                            isSelected: (viewModel.selectedBottleTime == item.displayName),
                            onTap: {
                                viewModel.selectedBottleTime = item.displayName
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
                            showBottleTimePicker = true
                        },
                        cornerRadius: 8
                    )
                    .sheet(isPresented: $showBottleTimePicker) {
                        timePickerSheet(
                            selectedDate: $selectedBottleTimeDate,
                            onDone: {
                                let timeString = selectedBottleTimeDate.formatTime()
                                viewModel.addCustomBottleTime(timeString)
                                viewModel.selectedBottleTime = timeString
                                showBottleTimePicker = false
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(.leading, Spacing.xxs)
                
                VStack {
                    Text(Constants.ouncesmL)
                        .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: Spacing.s) {
                        TagCloudView(data: viewModel.allOunces) { ounce in
                            BorderTagButton(
                                title: ounce,
                                isSelected: viewModel.selectedOunces == ounce,
                                onTap: {
                                    viewModel.selectedOunces = ounce
                                },
                                cornerRadius: 8
                            )
                        }
                    }
                    
                    HStack {
                        BorderTagButton(
                            title: "+ Add custom",
                            isSelected: false,
                            onTap: {
                                showCustomOuncesPicker = true
                            },
                            cornerRadius: 8
                        )
                        .sheet(isPresented: $showCustomOuncesPicker) {
                            CustomOuncesInputSheetView(
                                inputText: $customOuncesInput,
                                onDone: {
                                    if !customOuncesInput.isEmpty {
                                        viewModel.addCustomOunce(customOuncesInput)
                                        viewModel.selectedOunces = customOuncesInput
                                        customOuncesInput = ""
                                        showCustomOuncesPicker = false
                                    }
                                },
                                onDismiss: {
                                    customOuncesInput = ""
                                    showCustomOuncesPicker = false
                                }
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, Spacing.xxs)
                }
                .padding(.top, Spacing.m)
                
                // Bottling Instructions Notes
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(Constants.bottlingNotes)
                        .appFont(name: .montserrat, weight: .bold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $viewModel.bottlingInstructions)
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .padding(Spacing.xs)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focusedField == .bottlingInstructions ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if viewModel.bottlingInstructions.isEmpty {
                                    VStack {
                                        HStack {
                                            Text(Constants.feedingNotesPlaceholder)
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
                        .focused($focusedField, equals: .bottlingInstructions)
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
}

// MARK: - Helper Functions
extension CreateMealsAndBottlesScreenView {
    
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
}

struct CustomOuncesInputSheetView: View {
    @Binding var inputText: String
    var onDone: () -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        CustomInputSheetView(
            title: "Add Custom Ounces/mL",
            instructionText: "Enter custom ounces/mL value:",
            placeholder: "e.g., 100mL (3.4 Oz)",
            inputText: $inputText,
            onDone: onDone,
            onDismiss: onDismiss
        )
    }
}

#Preview {
    NavigationStack {
        CreateMealsAndBottlesScreenView()
    }
}
