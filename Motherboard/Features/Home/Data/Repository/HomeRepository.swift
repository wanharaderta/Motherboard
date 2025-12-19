//
//  HomeRepository.swift
//  Motherboard
//
//  Created by Wanhar on 17/12/25.
//

import Foundation
import FirebaseFirestore

protocol HomeRepository {
    func addAllergy(
        userID: String,
        allergy: AllergyModelRequest
    ) async throws -> String
    
    func addMedicalCondition(
        userID: String,
        medicalCondition: MedicalConditionModelRequest
    ) async throws -> String
    
    func addMedication(
        userID: String,
        medication: MedicationModelRequest
    ) async throws -> String
    
    func addEmergencyMedication(
        userID: String,
        emergencyMedication: EmergencyMedicationModelRequest
    ) async throws -> String
    
    func addSpecialistInfo(
        userID: String,
        info: SpecialistInforModelRequest
    ) async throws -> String
    
    func addRoutine(
        userID: String,
        routine: RoutineModelRequest
    ) async throws -> String
}

class HomeRepositoryImpl: HomeRepository {
    
    func addAllergy(
        userID: String,
        allergy: AllergyModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.allergy(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: allergy)
    }
    
    func addMedicalCondition(
        userID: String,
        medicalCondition: MedicalConditionModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.medicalCondition(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: medicalCondition)
    }
    
    func addMedication(
        userID: String,
        medication: MedicationModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.medications(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: medication)
    }
    
    func addEmergencyMedication(
        userID: String,
        emergencyMedication: EmergencyMedicationModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.emergencyMedication(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: emergencyMedication)
    }
    
    func addSpecialistInfo(
        userID: String,
        info: SpecialistInforModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.specialistInfo(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: info)
    }
    
    func addRoutine(
        userID: String,
        routine: RoutineModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.routines(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: routine)
    }
    
}
