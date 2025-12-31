//
//  CreateMedicationsViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 31/12/25.
//

import Foundation
import UIKit

@MainActor
@Observable
final class CreateMedicationsViewModel: BaseViewModel {
    
    // MARK: - Dependencies
    private let repository: RoutinesRepository = RoutinesRepositoryImpl()
    private let homeRepository: HomeRepository = HomeRepositoryImpl()
    private let storageManager = StorageManager.shared
    private let authManager = AuthManager.shared
    
    // MARK: - Variable    
    var medicationRequest: MedicationModelRequest = MedicationModelRequest()
    
    // MARK: - Repeat Frequency
    var selectedRepeatFrequency: String? = RepeatFrequency.everyDay.rawValue
    
    // MARK: - Image Upload (Max 3 photos)
    var selectedImagesData: [Data] = []
    var selectedImages: [UIImage] = []
    var kidID: String = ""
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        guard let medicationName = medicationRequest.medicationName, !medicationName.isEmpty else {
            return false
        }
        return !selectedImages.isEmpty
    }
    
    // MARK: - Create Routine
    func createRoutine() async {
        // Start loading
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        defer {
            isLoading = false
        }
        
        // Validate medication name
        guard let medicationName = medicationRequest.medicationName, !medicationName.isEmpty else {
            errorMessage = "Please enter medication name"
            return
        }
        
        // Validate kidID
        guard !kidID.isEmpty else {
            errorMessage = "Kid ID is required"
            return
        }
        
        // Get user ID
        guard let userID = authManager.userData?.id else {
            errorMessage = "User not authenticated"
            return
        }
        
        do {
            // 1. Upload medication images to Firebase Storage (for medications collection)
            var medicationImageURLs: [String] = []
            if !selectedImages.isEmpty {
                for (index, image) in selectedImages.enumerated() {
                    let imagePath = "medications/\(userID)/"
                    let fileName = "\(UUID().uuidString)_\(index).jpg"
                    let gsURL = try await storageManager.uploadImage(
                        image: image,
                        path: imagePath,
                        fileName: fileName,
                        compressionQuality: 0.7
                    )
                    medicationImageURLs.append(gsURL)
                }
                medicationRequest.medicationImageURL = medicationImageURLs
            }
            
            // 2. Set default values if nil (like InitialViewModel)
            if medicationRequest.dose == nil {
                medicationRequest.dose = .mgML
            }
            if medicationRequest.route == nil {
                medicationRequest.route = .oral
            }
            if medicationRequest.frequency == nil {
                medicationRequest.frequency = .daily
            }
            
            // 3. Set kidID to medicationRequest
            medicationRequest.kidID = kidID
            
            // 4. Save medication to medications collection
            let medicationID = try await homeRepository.addMedication(
                userID: userID,
                medication: medicationRequest
            )
            print("✅ Add medication successful - Medication ID: \(medicationID)")
            
            // 5. Upload images for routine (for routines collection)
            var routineImageURLs: [String] = []
            for (index, image) in selectedImages.enumerated() {
                let imagePath = "routines/\(userID)/"
                let fileName = "\(UUID().uuidString)_\(index).jpg"
                let gsURL = try await storageManager.uploadImage(
                    image: image,
                    path: imagePath,
                    fileName: fileName,
                    compressionQuality: 0.7
                )
                routineImageURLs.append(gsURL)
            }
            
            // 6. Create routine request
            let routine = RoutineModelRequest(
                code: RoutineType.medications.code,
                title: medicationName,
                description: medicationRequest.doctorsNote ?? "",
                kidID: kidID,
                activityName: medicationRequest.medicationName,
                scheduledTime: medicationRequest.timeSchedule,
                instructions: medicationRequest.doctorsNote,
                quantitySchedule: nil,
                quantityValue: medicationRequest.dose?.rawValue,
                quantityInstructions: nil,
                repeatFrequency: selectedRepeatFrequency,
                imageURLs: routineImageURLs,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            // 7. Save routine to routines collection
            let routineID = try await repository.addRoutine(userID: userID, routine: routine)
            print("✅ Routine created successfully with ID: \(routineID)")
            
            // Set success state
            isSuccess = true
            
            // Reset form after success
            resetForm()
            
        } catch {
            errorMessage = error.localizedDescription
            isSuccess = false
        }
    }
    
    // MARK: - Reset Form
    private func resetForm() {
        medicationRequest = MedicationModelRequest()
        selectedRepeatFrequency = RepeatFrequency.everyDay.rawValue
        selectedImagesData = []
        selectedImages = []
    }
}
