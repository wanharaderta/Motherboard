//
//  FirestoreFieldKey.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

enum FirestoreFieldKey {
    case createdAt
    case kidID
    
    var key: String {
        switch self {
        case .createdAt: return "createdAt"
        case .kidID: return "kidID"
        }
    }
}
