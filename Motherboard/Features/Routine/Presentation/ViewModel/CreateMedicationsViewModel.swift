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
            // 1. Upload images in parallel (optimized)
            var allImageURLs: [String] = []
            if !selectedImages.isEmpty {
                // Upload all images concurrently using TaskGroup while maintaining order
                allImageURLs = try await withThrowingTaskGroup(of: (Int, String).self) { group in
                    var urlDict: [Int: String] = [:]
                    
                    for (index, image) in selectedImages.enumerated() {
                        group.addTask {
                            let imagePath = "medications/\(userID)/"
                            let fileName = "\(UUID().uuidString)_\(index).jpg"
                            let url = try await self.storageManager.uploadImage(
                                image: image,
                                path: imagePath,
                                fileName: fileName,
                                compressionQuality: 0.7
                            )
                            return (index, url)
                        }
                    }
                    
                    for try await (index, url) in group {
                        urlDict[index] = url
                    }
                    
                    // Reconstruct array in original order
                    return selectedImages.indices.compactMap { urlDict[$0] }
                }
                
                // Use same URLs for both collections (no need to upload twice)
                medicationRequest.medicationImageURL = allImageURLs
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
            
            // 4. Create routine request (using same image URLs)
            let routine = RoutineModelRequest(
                code: RoutineType.medications.code,
                title: medicationName,
                description: medicationRequest.doctorsNote ?? "",
                kidID: kidID,
                activityName: medicationRequest.medicationName,
                scheduledTime: medicationRequest.medicationStartDate,
                endScheduledTime: medicationRequest.medicationEndDate,
                instructions: medicationRequest.doctorsNote,
                quantitySchedule: nil,
                quantityValue: medicationRequest.dose?.rawValue,
                quantityInstructions: nil,
                repeatFrequency: selectedRepeatFrequency,
                intervalHours: medicationRequest.intervalHour,
                imageURLs: allImageURLs,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            // 5. Save medication and create routine concurrently
            async let medicationID = homeRepository.addMedication(
                userID: userID,
                medication: medicationRequest
            )
            
            async let routineID = repository.addRoutine(userID: userID, routine: routine)
            
            // Wait for both operations to complete
            let finalMedicationID = try await medicationID
            let finalRoutineID = try await routineID
            
            print("✅ Add medication successful - Medication ID: \(finalMedicationID)")
            print("✅ Routine created successfully with ID: \(finalRoutineID)")
            
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

// MARK: - Extension
extension CreateMedicationsViewModel {
    // MARK: - End Scheduled Time (scheduledTime + 30 minutes)
    var endScheduledTime: String? {
        guard let timeSchedule = medicationRequest.timeSchedule, !timeSchedule.isEmpty else { return nil }
        
        // Try to parse as time string first (hh:mma format)
        if let timeDate = Date.parseTime(from: timeSchedule) {
            // Add 30 minutes
            let endTime = timeDate.addingMinutes(30)
            // Format back to string
            return endTime.formatTime()
        }
        return nil
    }
}
