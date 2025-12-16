//
//  InitialViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 15/12/25.
//

import Foundation
import UIKit
import FirebaseFirestore

@MainActor
@Observable
class InitialViewModel: BaseViewModel {
    
    // MARK: - User Role Data
    var selectedRole: UserRoleModel?
    
    // MARK: - Child Data
    var childRequest: KidModelRequest = KidModelRequest()
    var childSelectedImage: UIImage?
    var childPhotoUrl: String = ""
    
    // MARK: - Allergy Data
    var allergyRequest: AllergyModelRequest = AllergyModelRequest()
    
    // MARK: - Medical Condition Data
    var conditionName: String = ""
    var conditionDescription: String = ""
    var doctorsInstructions: String = ""
    var startDate: Date = Date()
    var ongoing: Ongoing = .yes
    
    // MARK: - Medication Data
    var medicationName: String = ""
    var dose: MedicationDose = .mgML
    var route: MedicationRoute = .oral
    var frequency: MedicationFrequency = .daily
    var timeSchedule: String = ""
    var medicationStartDate: String = ""
    var medicationEndDate: String = ""
    var doctorsNote: String = ""
    var medicationImage: UIImage?
    
    // MARK: - Emergency Medication Data
    var autoInjectorBrand: String = ""
    var emergencyDose: MedicationDose = .mgML
    var whenToAdminister: String = ""
    var followUpSteps: String = ""
    var instructionalYouTubeLink: String = ""
    var doctorContact: String = ""
    
    // MARK: - Specialist Information Data
    var doctorName: String = ""
    var practiceName: String = ""
    var specialistPhone: String = ""
    var specialistAddress: String = ""
    var portalLink: String = ""
    
    // MARK: - Routines Data
    var selectedRoutines: Set<RoutineType> = []
    
    // MARK: - Dependencies
    private let kidsRepository: KidsRepository = KidsRepositoryImpl()
    private let userRepository: UserRepository = UserRepositoryImpl()
    private let storageManager = StorageManager.shared
    
    // MARK: - Validation
    
    func validateChildData() -> Bool {
        let name = (childRequest.fullname ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return !name.isEmpty
    }
    
    func validateRoutines() -> Bool {
        !selectedRoutines.isEmpty
    }
    
    // MARK: - Camera Image Handling
    func handleCameraImage(_ image: UIImage) {
        childSelectedImage = image
        childPhotoUrl = ""          // clear previous URL when new image is captured
        childRequest.photoUrl = ""  // keep request in sync
    }

    /// Build KidsModelResponse from KidModelRequest for Firestore
    private func makeKidResponse(from request: KidModelRequest) -> KidsModelResponse {
        let now = Date()
        let fullname = request.fullname ?? ""
        let nickname = (request.nickname?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
            ? (request.nickname ?? "")
            : fullname
        let dob = request.dob ?? Date()
        let genderEnum = request.gender ?? .male
        let photoUrl = request.photoUrl ?? childPhotoUrl
        let notes = request.notes ?? ""

        return KidsModelResponse(
            fullname: fullname,
            dob: dob,
            gender: genderEnum.rawValue,
            nickname: nickname,
            photoUrl: photoUrl,
            notes: notes,
            createdAt: now,
            updatedAt: now
        )
    }

    // MARK: - Save Kid using KidModelRequest
    func saveInitialKid() async {
        guard validateChildData() else {
            showError(message: Constants.pleaseEnterFullname)
            return
        }

        guard let userID = AuthManager.shared.currentUserID else {
            showError(message: Constants.noUserIDAvailable)
            return
        }

        await withLoading {
            // TODO: handle upload image for childSelectedImage and set childRequest.photoUrl
            let request = childRequest
            let kidResponse = makeKidResponse(from: request)

            do {
                _ = try await kidsRepository.addKid(userID: userID, kid: kidResponse)
            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }
}
