//
//  MedicalConditionModelRequest.swift
//  Motherboard
//
//  Created by Wanhar on 16/12/25.
//

import Foundation

struct MedicalConditionModelRequest: Codable {
    var conditionName: String?
    var conditionDescription: String?
    var doctorsInstructions: String?
    var startDate: Date?
    var ongoing: Ongoing?
    var kidID: String?
}
