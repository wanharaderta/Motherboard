//
//  KidsRepository.swift
//  Motherboard
//
//  Created by Wanhar on 29/11/25.
//

import Foundation
import FirebaseFirestore

protocol KidsRepository {
    func listenToKids(
        userID: String,
        onUpdate: @escaping (Result<[KidsModelResponse],Error>) -> Void
    ) -> ListenerRegistration
    func addKid(
        userID: String,
        kid: KidsModelResponse
    ) async throws -> String
}

class KidsRepositoryImpl: KidsRepository {
    func listenToKids(
        userID: String,
        onUpdate: @escaping (Result<[KidsModelResponse],Error>) -> Void
    ) -> ListenerRegistration {
        let path = FirestoreCollection.kids(userID: userID).path
        let listener = FirestoreService.shared.listenToCollectionWithID(
            collection: path,
            as: KidsModelResponse.self
        ) { result in
            switch result {
            case .success(let docs):
                let models = docs.map { id, data in
                    var kid = data; kid.id = id; return kid
                }
                // cache
                DispatchQueue.main.async { onUpdate(.success(models)) }
                
            case .failure(let e):
                DispatchQueue.main.async { onUpdate(.failure(e)) }
            }
        }
        return listener
    }
    
    func addKid(
        userID: String,
        kid: KidsModelResponse
    ) async throws -> String {
        let path = FirestoreCollection.kids(userID: userID).path
        return try await FirestoreService.shared.addDocument(collection: path, data: kid)
    }
}
