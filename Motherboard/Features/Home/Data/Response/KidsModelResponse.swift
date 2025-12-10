//
//  Untitled.swift
//  Motherboard
//
//  Created by Wanhar on 29/11/25.
//

import Foundation
import FirebaseFirestore

struct KidsModelResponse: Codable, Identifiable {
    var id = ""
    let fullname: String
    let dob: Date
    let gender: Int // 0 = male, 1 = female, 2 = other
    let nickname: String
    let photoUrl: String
    let notes: String
    let createdAt: Date
    let updatedAt: Date
    
    var name: String {
        fullname
    }
    
    var age: String {
        dob.ageString()
    }
    
    var genderEnum: Gender {
        Gender(rawValue: gender) ?? .male
    }
    
    enum CodingKeys: String, CodingKey {
        case fullname
        case dob
        case gender
        case nickname
        case photoUrl
        case notes
        case createdAt
        case updatedAt
    }
}
