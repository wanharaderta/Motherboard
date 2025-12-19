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
        
        let listener = FirestoreService.shared.listenToCollectionWithID(
            collection: path,
            as: UserModelResponse.self
        ) { result in
            switch result {
            case .success(let docs):
                if let (docID, userData) = docs.first(where: { $0.id == userID }) {
                    var user = userData
                    user.id = docID
                    DispatchQueue.main.async { onUpdate(.success(user)) }
                } else {
                    DispatchQueue.main.async { onUpdate(.success(nil)) }
                }
                
            case .failure(let e):
                DispatchQueue.main.async { onUpdate(.failure(e)) }
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
