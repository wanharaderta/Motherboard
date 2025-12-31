//
//  RoutinesRepository.swift
//  Motherboard
//
//  Created by Wanhar on 29/12/25.
//

import Foundation
import FirebaseFirestore

protocol RoutinesRepository {
    func addRoutine(
        userID: String,
        routine: RoutineModelRequest
    ) async throws -> String
}

class RoutinesRepositoryImpl: RoutinesRepository {
    func addRoutine(
        userID: String,
        routine: RoutineModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.routines(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: routine)
    }
}
