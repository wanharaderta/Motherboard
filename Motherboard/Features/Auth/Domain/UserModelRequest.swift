//
//  UserModelRequest.swift
//  Motherboard
//
//  Created by Wanhar on 11/12/25.
//


import Foundation

struct UserModelRequest: Codable {
    let name: String
    let email: String
    let planType: PlanType
    let maxKids: Int
    let roleCaregiver: Bool
    let roleParent: Bool
    let createdAt: Date
    let updatedAt: Date
}
