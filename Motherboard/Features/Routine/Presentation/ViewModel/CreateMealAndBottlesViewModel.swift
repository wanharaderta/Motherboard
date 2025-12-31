//
//  CreateMealAndBottlesViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 25/12/25.
//

import Foundation
import UIKit

@MainActor
@Observable
final class CreateMealAndBottlesViewModel: BaseViewModel {
    
    // MARK: - Dependencies
    private let repository: RoutinesRepository = RoutinesRepositoryImpl()
    private let storageManager = StorageManager.shared
    private let authManager = AuthManager.shared
    
    // MARK: - Enums
    enum Field {
        case routineTitle, feedingInstructions, bottlingInstructions, customOunces
    }
    
    // MARK: - Meal Schedule
    var selectedMealName: MealName? = .breakfast
    var selectedMealTime: String? = DefaultTime.eightAM.rawValue
    var customMealTimes: [String] = []
    var feedingInstructions: String = ""
    
    // MARK: - Bottle Schedule
    var selectedBottleTime: String? = DefaultTime.eightAM.rawValue
    var customBottleTimes: [String] = []
    var selectedOunces: String? = DefaultOunces.fiftyML.rawValue
    var customOunces: [String] = []
    var bottlingInstructions: String = ""
    
    // MARK: - Routine Title
    var routineTitle: String = ""
    
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
    var allMealTimes: [TimeItem] {
        var times: [TimeItem] = DefaultTime.allCases.map { TimeItem.defaultTime($0) }
        times.append(contentsOf: customMealTimes.map { TimeItem.customTime($0) })
        return times
    }
    
    var allBottleTimes: [TimeItem] {
        var times: [TimeItem] = DefaultTime.allCases.map { TimeItem.defaultTime($0) }
        times.append(contentsOf: customBottleTimes.map { TimeItem.customTime($0) })
        return times
    }
    
    var allOunces: [String] {
        var ounces = DefaultOunces.allCases.map { $0.rawValue }
        ounces.append(contentsOf: customOunces)
        return ounces
    }
    
    var isFormValid: Bool {
        return !routineTitle.isEmpty && !selectedImages.isEmpty
    }
    
    // MARK: - Methods
    func addCustomMealTime(_ timeString: String) {
        if !customMealTimes.contains(timeString) {
            customMealTimes.append(timeString)
        }
    }
    
    func addCustomBottleTime(_ timeString: String) {
        if !customBottleTimes.contains(timeString) {
            customBottleTimes.append(timeString)
        }
    }
    
    func removeCustomMealTime(_ timeString: String) {
        customMealTimes.removeAll { $0 == timeString }
    }
    
    func removeCustomBottleTime(_ timeString: String) {
        customBottleTimes.removeAll { $0 == timeString }
    }
    
    func addCustomOunce(_ ounceString: String) {
        if !customOunces.contains(ounceString) {
            customOunces.append(ounceString)
        }
    }
    
    func removeCustomOunce(_ ounceString: String) {
        customOunces.removeAll { $0 == ounceString }
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
                code: RoutineType.bottlesAndMeals.code,
                title: routineTitle,
                description: feedingInstructions.isEmpty ? (bottlingInstructions.isEmpty ? "" : bottlingInstructions) : feedingInstructions,
                kidID: kidID,
                activityName: selectedMealName?.rawValue,
                scheduledTime: selectedMealTime,
                instructions: feedingInstructions.isEmpty ? nil : feedingInstructions,
                quantitySchedule: selectedBottleTime,
                quantityValue: selectedOunces,
                quantityInstructions: bottlingInstructions.isEmpty ? nil : bottlingInstructions,
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
        routineTitle = ""
        selectedMealName = .breakfast
        selectedMealTime = DefaultTime.eightAM.rawValue
        feedingInstructions = ""
        selectedBottleTime = DefaultTime.eightAM.rawValue
        selectedOunces = DefaultOunces.fiftyML.rawValue
        bottlingInstructions = ""
        selectedRepeatFrequency = RepeatFrequency.everyDay.rawValue
        selectedImagesData = []
        selectedImages = []
    }
}
