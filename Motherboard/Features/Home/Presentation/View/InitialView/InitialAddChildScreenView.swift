//
//  OnboardingAddChildScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 12/12/25.
//

import SwiftUI
import PhotosUI
import UIKit
import SDWebImageSwiftUI
import AVFoundation

struct InitialAddChildScreenView: View {
    
    // MARK: - Properties
    @Environment(InitialViewModel.self) private var viewModel
    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    
    @FocusState private var focusedField: Field?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDatePicker = false
    @State private var showCamera = false
    
    // MARK: - Enums
    enum Field {
        case childsName, dateOfBirth, gender
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                headerView
                contentView
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color.white.ignoresSafeArea())
        .alert(Constants.error, isPresented: Binding(get: { viewModel.isError }, set: { if !$0 { viewModel.clearError() } })) {
            Button(Constants.ok) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? Constants.errorOccurred)
        }
        .sheet(isPresented: $showCamera) {
            CameraPickerManager(selectedImage: $selectedImage)
                .onChange(of: selectedImage) { _, newValue in
                    if let newValue = newValue {
                        handleCameraImage(newValue)
                    }
                }
        }
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let newValue = newValue {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        viewModel.childSelectedImage = image
                        viewModel.childRequest.photoUrl = nil
                    }
                } else {
                    selectedImage = nil
                    viewModel.childSelectedImage = nil
                    viewModel.childRequest.photoUrl = nil
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button(action: {
                withAnimation {
                    navigationCoordinator.pop()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.tundora)
                    .font(.system(size: 20, weight: .medium))
            }
            
            Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal, Spacing.xl)
        .background(Color.white)
    }
    
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text(Constants.addYourChild)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                    .foregroundColor(Color.codGreyText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(Constants.addDetailsAboutYourChildToContinue)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .foregroundColor(Color.mineShaftOpacity86)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, Spacing.xl)
            
            VStack(alignment: .leading, spacing: Spacing.xl) {
                formFields
                imageUploadSection
                continueButton
                
                Spacer()
                    .frame(height: Spacing.xl)
            }
            .padding([.top, .horizontal], Spacing.xl)
        }
    }
}

// MARK: - Sub Item View
extension InitialAddChildScreenView {
    // MARK: - Form Fields
    private var formFields: some View {
        VStack(spacing: Spacing.l) {
            LabeledInputField(
                label: Constants.childsName,
                placeholder: Constants.fullname,
                text: Binding(
                    get: { viewModel.childRequest.fullname ?? "" },
                    set: { viewModel.childRequest.fullname = $0 }
                ),
                labelColor: Color.black300,
                textPlaceholderColor: Color.mainGray,
                field: .childsName,
                focus: $focusedField
            )
            dateOfBirthField
            genderField
        }
    }
    
    // MARK: - Date of Birth Field
    private var dateOfBirthField: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(Constants.dateOfBirthLabel)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            HStack(spacing: 0) {
                TextField(
                    Constants.dateFormatPlaceholder,
                    text: .constant((viewModel.childRequest.dob ?? Date()).formatDate())
                )
                    .textFieldStyle(.plain)
                    .disabled(true)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .padding(Spacing.m)
                
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Image("icCalendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 40)
                .padding(.trailing, Spacing.xs)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(focusedField == .dateOfBirth ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
            )
            .onTapGesture {
                focusedField = .dateOfBirth
                showDatePicker.toggle()
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.childRequest.dob ?? Date() },
                            set: { viewModel.childRequest.dob = $0 }
                        ),
                        displayedComponents: .date
                    )
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
    }
    
    // MARK: - Gender Field
    private var genderField: some View {
        MenuField(
            label: Constants.genderLabel,
            selectedValue: Binding(
                get: { viewModel.childRequest.gender },
                set: { viewModel.childRequest.gender = $0 }
            ),
            field: Field.gender,
            focus: $focusedField,
            labelColor: Color.mineShaftOpacity86,
            backgroundColor: Color.white
        )
    }
    
    // MARK: - Image Upload Section
    private var imageUploadSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text(Constants.childsImage)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaft)
            
            if let image = selectedImage ?? viewModel.childSelectedImage {
                VStack(spacing: Spacing.m) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 170)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button(action: {
                        selectedPhoto = nil
                        selectedImage = nil
                        viewModel.childSelectedImage = nil
                        viewModel.childRequest.photoUrl = nil
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
                        
                        HStack(spacing: 0) {
                            Text(Constants.please)
                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                .foregroundColor(Color.black200)
                            
                            Text(Constants.tapToUpload)
                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                .foregroundColor(Color.grey500)
                            
                            Text(Constants.yourChildsPicture)
                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                .foregroundColor(Color.black200)
                        }
                        .padding(.top, Spacing.xxs)
                        
                        Text(Constants.or)
                            .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                            .foregroundColor(Color.grey500)
                        
                        Button(action: {
                            openCamera()
                        }) {
                            Text(Constants.openCamera)
                                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                                .foregroundColor(Color.white)
                                .frame(width: 191, height: 33)
                                .background(Color.primaryGreen900)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
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
            handleContinue()
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
extension InitialAddChildScreenView {
    // MARK: - Validation
    private var isFormValid: Bool {
        validateChildData()
    }
    
    private func validateChildData() -> Bool {
        let name = (viewModel.childRequest.fullname ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return !name.isEmpty
    }
    
    private func validateForm() -> Bool {
        if !validateChildData() {
            viewModel.showError(message: Constants.pleaseEnterFullname)
            return false
        }
        return true
    }
    
    private func handleContinue() {
        guard validateForm() else {
            return
        }
        let name = viewModel.childRequest.fullname ?? ""
        if (viewModel.childRequest.nickname ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel.childRequest.nickname = name
        }
        navigationCoordinator.navigate(to: InitialRoute.healthMedicalInfo)
    }
    
    // MARK: - Camera Handling
    private func handleCameraImage(_ image: UIImage) {
        viewModel.childSelectedImage = image
        viewModel.childRequest.photoUrl = ""
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            viewModel.showError(message: "Camera is not available on this device")
            return
        }
        
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) else {
            viewModel.showError(message: "Rear camera is not available")
            return
        }
        
        showCamera = true
    }
}

#Preview {
    NavigationStack {
        InitialAddChildScreenView()
    }
}
