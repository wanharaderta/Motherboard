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
    
    func listenToRoutines(
        userID: String,
        onUpdate: @escaping (Result<[RoutinesModelResponse], Error>) -> Void
    ) -> ListenerRegistration
}

class RoutinesRepositoryImpl: RoutinesRepository {
    func addRoutine(
        userID: String,
        routine: RoutineModelRequest
    ) async throws -> String {
        let path = FirestoreCollection.routines(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: routine)
    }
    
    func listenToRoutines(
        userID: String,
        onUpdate: @escaping (Result<[RoutinesModelResponse], Error>) -> Void
    ) -> ListenerRegistration {
        let path = FirestoreCollection.routines(userID: userID).path
        
        // Filter by selectedKidID from UserDefaults
        let selectedKidID = UserDefaultsConfig.selectedKidID
        let filters: [(String, Any, QueryOperator)] = selectedKidID.isEmpty ? [] : [
            ("kidID", selectedKidID, QueryOperator.isEqualTo)
        ]
        
        let listener = FirestoreService.shared.listenToCollectionWithID(
            collection: path,
            as: RoutinesModelResponse.self,
            filters: filters
        ) { result in
            switch result {
            case .success(let docs):
                let models = docs.map { id, data in
                    var routine = data
                    routine.id = id
                    return routine
                }
                DispatchQueue.main.async { onUpdate(.success(models)) }
                
            case .failure(let e):
                DispatchQueue.main.async { onUpdate(.failure(e)) }
            }
        }
        return listener
    }
}
