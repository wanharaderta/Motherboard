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
    
    // MARK: - Dependencies
    private let kidsRepository: KidsRepository = KidsRepositoryImpl()
    private let userRepository: UserRepository = UserRepositoryImpl()
    private let homeRepository: HomeRepository = HomeRepositoryImpl()
    private let storageManager = StorageManager.shared
    private let authManager = AuthManager.shared
    
    
    // MARK: - User Role Data
    var selectedRole: UserRoleModel?
    
    // MARK: - Child Data
    var childRequest: KidModelRequest = KidModelRequest()
    var childSelectedImage: UIImage?
    var kidID: String?
    
    // MARK: - Allergy Data
    var allergyRequest: AllergyModelRequest = AllergyModelRequest()
    
    // MARK: - Medical Condition Data
    var medicalConditionRequest: MedicalConditionModelRequest = MedicalConditionModelRequest()
    
    // MARK: - Medication Data
    var medicationRequest: MedicationModelRequest = MedicationModelRequest()
    
    // MARK: - Emergency Medication Data
    var emergencyMedicationRequest: EmergencyMedicationModelRequest = EmergencyMedicationModelRequest()
    
    // MARK: - Specialist Information Data
    var infoModelRequest: SpecialistInforModelRequest = SpecialistInforModelRequest()
    
    // MARK: - Routines Data
    var selectedRoutines: Set<RoutineType> = []
    
    
    // MARK: - Update User Role by Document ID
    func updateUserRole() async {
        guard let role = selectedRole else {
            showError(message: Constants.pleaseSelectARole)
            return
        }
        
        guard let userID = authManager.currentUserID else {
            showError(message: Constants.noUserIDAvailable)
            return
        }
        
        await withLoading {
            do {
                try await userRepository.updateUserRoleByDocumentID(
                    documentID: userID,
                    role: role
                )
            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Child
    func addChild() async {
        guard let userID = authManager.currentUserID else {
            showError(message: Constants.noUserIDAvailable)
            return
        }
        
        await withLoading {
            do {
                // Upload child image (optional) and set photoUrl on request
                if let image = childSelectedImage {
                    let path = "kids/\(userID)/"
                    let photoUrl = try await storageManager.uploadImage(
                        image: image,
                        path: path
                    )
                    
                    guard !photoUrl.isEmpty else {
                        showError(message: Constants.failedToGetImageURL)
                        return
                    }
                    
                    childRequest.photoUrl = photoUrl
                }
                
                let now = Date()
                let fullname = childRequest.fullname ?? ""
                let nickname = (childRequest.nickname?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
                    ? (childRequest.nickname ?? "")
                    : fullname
                
                let kidResponse = KidsModelResponse(
                    fullname: fullname,
                    dob: childRequest.dob ?? Date(),
                    gender: childRequest.gender.rawValue,
                    nickname: nickname,
                    photoUrl: childRequest.photoUrl ?? "",
                    notes: childRequest.notes ?? "",
                    createdAt: now,
                    updatedAt: now
                )
                
                let kidID = try await kidsRepository.addKid(userID: userID, kid: kidResponse)
                self.kidID = kidID
                
                // After child is created, persist all related onboarding data
                await addAllergy()
                await addMedicalCondition()
                await addMedication()
                await addEmergencyMedication()
                await addSpecialistInfo()
                await addRoutines()
                
                print("✅ Add child successful - Kid ID: \(kidID)")
            } catch {
                print("❌ Error adding child: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Allergy
    func addAllergy() async {
        guard let kidID = kidID else {
            showError(message: Constants.kidIDNotAvailable)
            return
        }
        
        await withLoading {
            do {
                if allergyRequest.severity == nil {
                    allergyRequest.severity = .mild
                }
                allergyRequest.kidID = kidID
                let allergyID = try await homeRepository.addAllergy(userID: authManager.currentUserID!, allergy: allergyRequest)
                print("✅ Add allergy successful - Allergy ID: \(allergyID)")
            } catch {
                print("❌ Error adding allergy: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Medical Condition
    func addMedicalCondition() async {
        guard let kidID = kidID else {
            showError(message: Constants.kidIDNotAvailable)
            return
        }
        
        await withLoading {
            do {
                if medicalConditionRequest.ongoing == nil {
                    medicalConditionRequest.ongoing = .yes
                }
                medicalConditionRequest.kidID = kidID
                let conditionID = try await homeRepository.addMedicalCondition(
                    userID: authManager.currentUserID!,
                    medicalCondition: medicalConditionRequest
                )
                print("✅ Add medical condition successful - Condition ID: \(conditionID)")
            } catch {
                print("❌ Error adding medical condition: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Medication
    func addMedication() async {
        guard let kidID = kidID else {
            showError(message: Constants.kidIDNotAvailable)
            return
        }

        await withLoading {
            do {
                // Upload medication image (optional) and set URL on request
                if let image = medicationRequest.medicationImage,
                   let userID = authManager.currentUserID {
                    let path = "medications/\(userID)/"
                    let imageURL = try await storageManager.uploadImage(
                        image: image,
                        path: path
                    )
                    
                    guard !imageURL.isEmpty else {
                        showError(message: Constants.failedToGetImageURL)
                        return
                    }
                    
                    medicationRequest.medicationImageURL = [imageURL]
                }

                if medicationRequest.dose == nil {
                    medicationRequest.dose = .mgML
                }
                if medicationRequest.route == nil {
                    medicationRequest.route = .oral
                }
                if medicationRequest.frequency == nil {
                    medicationRequest.frequency = .daily
                }

                medicationRequest.kidID = kidID
                let medicationID = try await homeRepository.addMedication(
                    userID: authManager.currentUserID!,
                    medication: medicationRequest
                )
                print("✅ Add medication successful - Medication ID: \(medicationID)")
            } catch {
                print("❌ Error adding medication: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Emergency Medication
    func addEmergencyMedication() async {
        guard let kidID = kidID else {
            showError(message: Constants.kidIDNotAvailable)
            return
        }
        
        await withLoading {
            do {
                if emergencyMedicationRequest.emergencyDose == nil {
                    emergencyMedicationRequest.emergencyDose = .mgML
                }
                
                emergencyMedicationRequest.kidID = kidID
                let emergencyMedicationID = try await homeRepository.addEmergencyMedication(
                    userID: authManager.currentUserID!,
                    emergencyMedication: emergencyMedicationRequest
                )
                print("✅ Add emergency medication successful - ID: \(emergencyMedicationID)")
            } catch {
                print("❌ Error adding emergency medication: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Specialist Info (without kidID)
    func addSpecialistInfo() async {
        await withLoading {
            do {
                let infoID = try await homeRepository.addSpecialistInfo(
                    userID: authManager.currentUserID!,
                    info: infoModelRequest
                )
                print("✅ Add specialist info successful - ID: \(infoID)")
            } catch {
                print("❌ Error adding specialist info: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Routines
    func addRoutines() async {
        guard let kidID = kidID else {
            showError(message: Constants.kidIDNotAvailable)
            return
        }
        
        guard let userID = authManager.currentUserID else {
            showError(message: Constants.noUserIDAvailable)
            return
        }
        
        await withLoading {
            do {
                for routine in selectedRoutines {
                    let request = RoutineModelRequest(
                        code: routine.code,
                        title: routine.title,
                        description: routine.description,
                        kidID: kidID
                    )
                    
                    let response = try await homeRepository.addRoutine(
                        userID: userID,
                        routine: request
                    )
                    
                    print("✅ Add routines successful - Count: \(response)")
                }
            } catch {
                print("❌ Error adding routines: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
    }
}
