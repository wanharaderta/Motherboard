//
//  OnboardingAddChildScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 12/12/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct OnboardingAddChildScreenView: View {
    var onContinue: (() -> Void)?
    @FocusState private var focusedField: Field?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCamera = false
    @State private var showImagePicker = false
    
    @State private var childsName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedGender: Gender? = nil
    @State private var showDatePicker = false
    
    enum Field {
        case childsName, dateOfBirth, gender
    }
    
    var body: some View {
        ZStack {
            Color.bgBridalHeath
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xl) {
                        // Header Section
                        headerView
                        
                        // Form Fields
                        formFields
                        
                        // Image Upload Section
                        imageUploadSection
                        
                        Spacer(minLength: Spacing.xxxl)
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.xl)
                }
                
                // Continue Button
                continueButton
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            Task {
                if let newValue = newValue {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                } else {
                    selectedImage = nil
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Add your child")
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundColor(Color.codGreyText)
            
            Text("Add details about your child to continue.")
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
        }
    }
    
    // MARK: - Form Fields
    private var formFields: some View {
        VStack(spacing: Spacing.l) {
            // Childs Name Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Childs Name:")
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .foregroundColor(Color.tundora)
                
                TextField("Placeholder", text: $childsName)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .childsName)
                    .padding(Spacing.m)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green200, lineWidth: 1)
                    )
            }
            
            // Date of Birth Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Date of Birth:")
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .foregroundColor(Color.tundora)
                
                HStack {
                    TextField("MM/DD/YYYY", text: .constant(formatDate(dateOfBirth)))
                        .textFieldStyle(.plain)
                        .disabled(true)
                        .padding(Spacing.m)
                    
                    Button(action: {
                        showDatePicker.toggle()
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(Color.tundora)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.trailing, Spacing.m)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green200, lineWidth: 1)
                )
                .sheet(isPresented: $showDatePicker) {
                    VStack {
                        DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                        
                        Button("Done") {
                            showDatePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.medium])
                }
            }
            
            // Gender Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Gender:")
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .foregroundColor(Color.tundora)
                
                Menu {
                    ForEach(Gender.allCases, id: \.self) { genderOption in
                        Button(action: {
                            selectedGender = genderOption
                        }) {
                            HStack {
                                Text(genderOption.displayName)
                                if selectedGender == genderOption {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedGender?.displayName ?? "Placeholder")
                            .foregroundColor(selectedGender == nil ? Color.gray.opacity(0.5) : Color.tundora)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.tundora)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(Spacing.m)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green200, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // MARK: - Image Upload Section
    private var imageUploadSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Childs Image:")
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.tundora)
            
            if let image = selectedImage {
                VStack(spacing: Spacing.m) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button(action: {
                        selectedImage = nil
                        selectedPhoto = nil
                    }) {
                        Text("Remove Photo")
                            .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                            .foregroundColor(.red)
                    }
                }
            } else {
                VStack(spacing: Spacing.m) {
                    // Upload Area
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        VStack(spacing: Spacing.m) {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.pampas)
                            
                            VStack(spacing: Spacing.xs) {
                                HStack(spacing: 0) {
                                    Text("Please, ")
                                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                        .foregroundColor(Color.mineShaftOpacity86)
                                    Text("tap to upload your child's picture")
                                        .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                                        .foregroundColor(Color.tundora)
                                }
                            }
                            
                            Text("Or")
                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                                .foregroundColor(Color.mineShaftOpacity86)
                                .padding(.top, Spacing.s)
                            
                            Button(action: {
                                showCamera = true
                            }) {
                                Text("Open Camera")
                                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.primaryGreen900)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal, Spacing.l)
                            .padding(.top, Spacing.s)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .padding(Spacing.l)
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
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                handleContinue()
            }) {
                Text("Continue")
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                    .foregroundColor(Color.green500)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green500, lineWidth: 1)
                    )
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.bgBridalHeath)
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    private func handleContinue() {
        // Handle continue action
        print("Child Name: \(childsName)")
        print("Date of Birth: \(formatDate(dateOfBirth))")
        if let gender = selectedGender {
            print("Gender: \(gender.displayName)")
        }
        print("Has Image: \(selectedImage != nil)")
        onContinue?()
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingAddChildScreenView()
    }
}
