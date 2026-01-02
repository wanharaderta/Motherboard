//
//  CreateDiapersViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 29/12/25.
//

import Foundation
import UIKit

@MainActor
@Observable
final class CreateDiapersViewModel: BaseViewModel {
    
    // MARK: - Dependencies
    private let repository: RoutinesRepository = RoutinesRepositoryImpl()
    private let storageManager = StorageManager.shared
    private let authManager = AuthManager.shared
    
    // MARK: - Variable
    var title: String = ""
    var customTimes: [String] = []
    var selectedType: DiapersType? = .wet
    var selectedTime: String? = DefaultTime.eightAM.rawValue
    var diapersInstructions: String = ""
    
    // MARK: - Repeat Frequency
    var selectedRepeatFrequency: String? = RepeatFrequency.everyDay.rawValue
    var dayRepeatRoutines: [String] = [
        RepeatFrequency.everyDay.rawValue,
        RepeatFrequency.weekdaysOnly.rawValue,
        RepeatFrequency.weekendsOnly.rawValue,
        RepeatFrequency.customDay.rawValue
    ]
    
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
    
    var isFormValid: Bool {
        return !title.isEmpty && !selectedImages.isEmpty
    }
    
    func addCustomTime(_ timeString: String) {
        if !customTimes.contains(timeString) {
            customTimes.append(timeString)
        }
    }
    
    // MARK: - Custom Day Selection
    func selectCustomDay(_ day: String) {
        // Validasi: hanya proses jika day belum ada di array
        guard !dayRepeatRoutines.contains(day) else { return }
        
        // Remove "+ Custom days" button dulu
        dayRepeatRoutines.removeAll { $0 == RepeatFrequency.customDay.rawValue }
        
        // Append selected day dan set sebagai selected
        dayRepeatRoutines.append(day)
        selectedRepeatFrequency = day
        
        if !dayRepeatRoutines.contains(RepeatFrequency.customDay.rawValue) {
            dayRepeatRoutines.append(RepeatFrequency.customDay.rawValue)
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
                code: RoutineType.diapers.code,
                title: title,
                description: diapersInstructions.isEmpty ? "" : diapersInstructions,
                kidID: kidID,
                activityName: selectedType?.rawValue,
                scheduledTime: selectedTime,
                endScheduledTime: endScheduledTime,
                instructions: diapersInstructions.isEmpty ? nil : diapersInstructions,
                quantitySchedule: nil,
                quantityValue: nil,
                quantityInstructions: nil,
                repeatFrequency: selectedRepeatFrequency,
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
        title = ""
        selectedType = .wet
        selectedTime = DefaultTime.eightAM.rawValue
        diapersInstructions = ""
        selectedRepeatFrequency = RepeatFrequency.everyDay.rawValue
        selectedImagesData = []
        selectedImages = []
        customTimes = []
    }
}

// MARK: - Extension
extension CreateDiapersViewModel {
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
