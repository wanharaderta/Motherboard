//
//  UserRepository.swift
//  Motherboard
//
//  Created by Wanhar on 11/12/25.
//

import Foundation
import FirebaseFirestore

protocol UserRepository {
    func addUser(userID: String, user: UserModelRequest) async throws
    func listenToUserByID(
        userID: String,
        onUpdate: @escaping (Result<UserModelResponse?, Error>) -> Void
    ) -> ListenerRegistration
    func updateUserRoleByDocumentID(documentID: String, role: UserRoleModel) async throws
}

class UserRepositoryImpl: UserRepository {
    func addUser(userID: String, user: UserModelRequest) async throws {
        let path = FirestoreCollection.users.path
        try await FirestoreService.shared.setDocument(
            collection: path,
            documentID: userID,
            data: user,
            merge: true
        )
    }
    
    func listenToUserByID(
        userID: String,
        onUpdate: @escaping (Result<UserModelResponse?, Error>) -> Void
    ) -> ListenerRegistration {
        let path = FirestoreCollection.users.path
        
        // Use listenToDocument to directly listen to the specific document by ID
        // This is more efficient for single document queries
        let listener = FirestoreService.shared.listenToDocument(
            collection: path,
            documentID: userID,
            as: UserModelResponse.self
        ) { result in
            switch result {
            case .success(let userData):
                if var user = userData {
                    // Set the document ID
                    user.id = userID
                    DispatchQueue.main.async { onUpdate(.success(user)) }
                } else {
                    // Document doesn't exist
                    DispatchQueue.main.async { onUpdate(.success(nil)) }
                }
            case .failure(let error):
                DispatchQueue.main.async { onUpdate(.failure(error)) }
            }
        }
        return listener
    }
    
    func updateUserRoleByDocumentID(documentID: String, role: UserRoleModel) async throws {
        let path = FirestoreCollection.users.path
        let roleData: [String: Any] = [
            "roleParent": role == .parent,
            "roleCaregiver": role == .caregiver,
            "updatedAt": Timestamp(date: Date())
        ]
        
        try await FirestoreService.shared.updateDocument(
            collection: path,
            documentID: documentID,
            fields: roleData
        )
    }
}
