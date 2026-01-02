//
//  MedicationModelRequest.swift
//  Motherboard
//
//  Created by Wanhar on 17/12/25.
//

import UIKit


struct MedicationModelRequest: Codable {
    var medicationName: String?
    var dose: MedicationDose?
    var route: MedicationRoute?
    var frequency: MedicationFrequency?
    var timeSchedule: String?
    var intervalHour: Int?
    var medicationStartDate: String?
    var medicationEndDate: String?
    var doctorsNote: String?
    var medicationImage: UIImage?
    var medicationImageURL: [String]?
    var kidID: String?
    
    enum CodingKeys: String, CodingKey {
        case medicationName
        case dose
        case route
        case frequency
        case timeSchedule
        case intervalHour
        case medicationStartDate
        case medicationEndDate
        case doctorsNote
        case medicationImageURL
        case kidID
    }
}
