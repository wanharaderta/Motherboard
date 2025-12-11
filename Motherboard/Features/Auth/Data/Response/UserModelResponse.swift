//
//  UserModelResponse.swift
//  Motherboard
//
//  Created by Wanhar on 11/12/25.
//

import Foundation

struct UserModelResponse: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let planType: Int
    let maxKids: Int
    let roleCaregiver: Bool
    let roleParent: Bool
    let createdAt: Date
    let updatedAt: Date
}
