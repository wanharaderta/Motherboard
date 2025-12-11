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
}
