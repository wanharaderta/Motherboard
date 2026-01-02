//
//  CreateBreastfeedingViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 31/12/25.
//

import Foundation
import UIKit

@MainActor
@Observable
final class CreateBreastViewModel: BaseViewModel {
    
    // MARK: - Dependencies
    private let repository: RoutinesRepository = RoutinesRepositoryImpl()
    private let storageManager = StorageManager.shared
    private let authManager = AuthManager.shared
    
    // MARK: - Variable
    var customTimes: [String] = []
    var selectedType: BreastType? = .right
    var selectedTime: String? = DefaultTime.eightAM.rawValue
    var breastInstructions: String = ""
    
    // MARK: - Pumping Variable
    var customPumpingTimes: [String] = []
    var selectedPumpingType: BreastType? = .right
    var selectedPumpingTime: String? = DefaultTime.eightAM.rawValue
    var pumpingInstructions: String = ""
    
    // MARK: - Image Upload (Max 3 photos)
    var selectedImagesData: [Data] = []
    var selectedImages: [UIImage] = []
    var kidID: String = ""
    
    // MARK: - Computed Properties
    var allTimes: [TimeItem] {
        var times: [TimeItem] = DefaultTime.allCases.map { TimeItem.defaultTime($0) }
        times.append(contentsOf: customTimes.map { TimeItem.customTime($0) })
        return times
    }
    
    var allPumpingTimes: [TimeItem] {
        var times: [TimeItem] = DefaultTime.allCases.map { TimeItem.defaultTime($0) }
        times.append(contentsOf: customPumpingTimes.map { TimeItem.customTime($0) })
        return times
    }
    
    var isFormValid: Bool {
        return !selectedImages.isEmpty
    }
    
    func addCustomTime(_ timeString: String) {
        if !customTimes.contains(timeString) {
            customTimes.append(timeString)
        }
    }
    
    func addCustomPumpingTime(_ timeString: String) {
        if !customPumpingTimes.contains(timeString) {
            customPumpingTimes.append(timeString)
        }
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
            // 1. Upload images to Firebase Storage
            var imageURLs: [String] = []
            for (index, image) in selectedImages.enumerated() {
                let imagePath = "routines/\(userID)/"
                let fileName = "\(UUID().uuidString)_\(index).jpg"
                let gsURL = try await storageManager.uploadImage(
                    image: image,
                    path: imagePath,
                    fileName: fileName,
                    compressionQuality: 0.7
                )
                imageURLs.append(gsURL)
            }
            
            // 2. Create routine request
            let routine = RoutineModelRequest(
                code: RoutineType.breastfeedingAndPumping.code,
                title: Constants.breastfeedingAndPumping,
                description: breastInstructions.isEmpty ? "" : breastInstructions,
                kidID: kidID,
                activityName: selectedType?.rawValue,
                scheduledTime: selectedTime,
                endScheduledTime: endScheduledTime,
                instructions: breastInstructions.isEmpty ? nil : breastInstructions,
                quantitySchedule: nil,
                quantityValue: nil,
                quantityInstructions: nil,
                repeatFrequency: nil,
                imageURLs: imageURLs,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            // 3. Save to Firestore
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
        selectedType = .right
        selectedTime = DefaultTime.eightAM.rawValue
        breastInstructions = ""
        selectedPumpingType = .right
        selectedPumpingTime = DefaultTime.eightAM.rawValue
        pumpingInstructions = ""
        selectedImagesData = []
        selectedImages = []
        customTimes = []
        customPumpingTimes = []
    }
}

// MARK: - Extension
extension CreateBreastViewModel {
    // MARK: - End Scheduled Time (scheduledTime + 30 minutes)
    var endScheduledTime: String? {
        guard let selectedTime = selectedTime else { return nil }
        
        // Parse time string to Date
        guard let timeDate = Date.parseTime(from: selectedTime) else { return nil }
        
        // Add 30 minutes
        let endTime = timeDate.addingMinutes(30)
        
        // Format back to string
        return endTime.formatTime()
    }
}
