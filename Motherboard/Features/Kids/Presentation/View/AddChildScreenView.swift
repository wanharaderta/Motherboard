//
//  AddChildScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 30/11/25.
//

import SwiftUI
import PhotosUI

struct AddChildScreenView: View {
    
    @State private var viewModel = AddChildViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    enum Field {
        case fullname, nickname, notes
    }
    
    var body: some View {
        ZStack {
            Color.bgBridalHeath
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    headerView
                    formView
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xl)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.mineShaft)
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
        .alert(Constants.error, isPresented: $viewModel.isError) {
            Button(Constants.ok) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? Constants.errorOccurred)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: Spacing.m) {
            Text(Constants.addChild)
                .appFont(name: .spProDisplay, weight: .semibold, size: FontSize.largeTitle30)
                .foregroundColor(Color.codGreyText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Form View
    private var formView: some View {
        VStack(spacing: Spacing.xl) {
            // Full Name Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.fullName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                
                TextField(Constants.enterFullname, text: $viewModel.fullname)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .fullname)
                    .padding(Spacing.m)
                    .background(Color.starkWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .fullname ? Color.summerGreen : Color.clear, lineWidth: 2)
                    )
            }
            
            // Nickname Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.nickname)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                
                TextField(Constants.enterNickname, text: $viewModel.nickname)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .nickname)
                    .padding(Spacing.m)
                    .background(Color.starkWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .nickname ? Color.summerGreen : Color.clear, lineWidth: 2)
                    )
            }
            
            // Date of Birth Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.dateOfBirth)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                
                DatePicker("", selection: $viewModel.dob, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding(Spacing.m)
                    .background(Color.starkWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Gender Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.gender)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                
                Picker("", selection: $viewModel.gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.displayName).tag(gender)
                    }
                }
                .pickerStyle(.segmented)
                .padding(Spacing.m)
                .background(Color.starkWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Notes Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.notes)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                
                ZStack(alignment: .topLeading) {
                    if viewModel.notesGeneral.isEmpty {
                        Text(Constants.enterNotes)
                            .font(.system(size: 16))
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, Spacing.m)
                            .padding(.top, Spacing.m)
                            .allowsHitTesting(false)
                    }
                    
                    TextEditor(text: $viewModel.notesGeneral)
                        .frame(minHeight: 100)
                        .padding(Spacing.xs)
                        .scrollContentBackground(.hidden)
                        .background(Color.starkWhite)
                }
                .background(Color.starkWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .notes ? Color.summerGreen : Color.clear, lineWidth: 2)
                )
                .onTapGesture {
                    focusedField = .notes
                }
            }
            
            // Photo Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.photo)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                
                if let image = selectedImage {
                    VStack(spacing: Spacing.m) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.summerGreen, lineWidth: 3))
                        
                        Button(action: {
                            selectedPhoto = nil
                            self.selectedImage = nil
                            viewModel.selectedImage = nil
                            viewModel.photoUrl = ""
                        }) {
                            Text("Remove Photo")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(Color.summerGreen)
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Add Photo")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.mineShaft)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.starkWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    if let newValue = newValue {
                        if let data = try? await newValue.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            viewModel.selectedImage = image
                            // Clear previous photo URL when new image is selected
                            viewModel.photoUrl = ""
                        }
                    } else {
                        // Clear image when photo picker is cancelled
                        selectedImage = nil
                        viewModel.selectedImage = nil
                        viewModel.photoUrl = ""
                    }
                }
            }
            
            // Save Button
            Button(action: {
                Task {
                    await viewModel.saveChild()
                    if viewModel.isSuccess {
                        dismiss()
                    }
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(Constants.save)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(viewModel.isLoading ? Color.summerGreen.opacity(0.6) : Color.summerGreen)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.isLoading)
            .padding(.top, Spacing.m)
            .padding(.bottom, Spacing.xxl)
        }
    }
}

#Preview {
    NavigationStack {
        AddChildScreenView()
    }
}
