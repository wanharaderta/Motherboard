//
//  Untitled.swift
//  Motherboard
//
//  Created by Wanhar on 16/12/25.
//

struct AllergyModelRequest: Codable {
    var allergyName: String?
    var severity: AllergySeverity?
    var triggerDetails: String?
    var reactionDescription: String?
    var specificInstructions: String?
    var kidID: String?
}
