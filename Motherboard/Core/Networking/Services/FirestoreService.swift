//
//  FirestoreService.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

enum QueryOperator {
    case isGreaterThanOrEqualTo
    case isLessThanOrEqualTo
    case isEqualTo
    case isGreaterThan
    case isLessThan
    case isNotEqualTo
}

enum FirestoreCollection {
    case users
    case usersByID(userID: String)
    case kids(userID: String)
    
    /// Use this property when passing to Firestore APIs
    var path: String {
        switch self {
        case .users:
            return "users"
        case .usersByID(let userID):
            return "users/\(userID)"
        case .kids(let userID):
            return "users/\(userID)/kids"
        }
    }
}

class FirestoreService {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    
    // MARK: - Get Documents with ID Sort, Real‐Time Listeners
    func listenToCollectionWithID<T: Decodable>(
        collection: String,
        as type: T.Type,
        filters: [(String,Any,QueryOperator)] = [],
        orderField: String? = nil,
        descending: Bool = false,
        onUpdate: @escaping (Result<[(id:String,data:T)],Error>) -> Void
    ) -> ListenerRegistration {
        
        var q: Query = db.collection(collection)
        
        for (field,value,op) in filters {
            switch op {
            case .isEqualTo:
                q = q.whereField(field, isEqualTo: value)
            case .isGreaterThan:
                q = q.whereField(field, isGreaterThan: value)
            case .isGreaterThanOrEqualTo:
                q = q.whereField(field, isGreaterThanOrEqualTo: value)
            case .isLessThan:
                q = q.whereField(field, isLessThan: value)
            case .isLessThanOrEqualTo:
                q = q.whereField(field, isLessThanOrEqualTo: value)
            case .isNotEqualTo:
                q = q.whereField(field, isNotEqualTo: value)
            }
        }
        
        if let o = orderField {
            q = q.order(by: o, descending: descending)
        }
        
        return q.addSnapshotListener { snap, err in
            if let err = err { return onUpdate(.failure(err)) }
            do {
                let items = try snap?.documents.compactMap { doc -> (String,T)? in
                    let m = try doc.data(as: T.self)
                    return (doc.documentID,m)
                } ?? []
                onUpdate(.success(items))
            } catch {
                onUpdate(.failure(error))
            }
        }
    }
    
    // MARK: - Add Document
    func addDocument<T: Encodable>(
        collection: String,
        data: T
    ) async throws -> String {
        let encoded = try Firestore.Encoder().encode(data)
        let ref = try await db.collection(collection).addDocument(data: encoded)
        return ref.documentID
    }
    
    // MARK: - Set/Upsert Document with Known ID
    func setDocument<T: Encodable>(
        collection: String,
        documentID: String,
        data: T,
        merge: Bool = true
    ) async throws {
        let encoded = try Firestore.Encoder().encode(data)
        try await db.collection(collection).document(documentID).setData(encoded, merge: merge)
    }
    
    // MARK: - Get Document
    func getDocument<T: Decodable>(
        collection: String,
        documentID: String,
        as type: T.Type
    ) async throws -> T {
        let doc = try await db.collection(collection).document(documentID).getDocument()
        guard doc.exists else {
            throw NSError(
                domain: "FirestoreService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Document not found"]
            )
        }
        return try doc.data(as: type)
    }
}
