//
//  ScheduledRoutineModel.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

import Foundation
import SwiftUI

struct RoutinesModelResponse: Codable, Identifiable {
    var id: String = "" // Document ID from Firebase
    var code: String
    var title: String
    var description: String
    var kidID: String

    var activityName: String?
    var scheduledTime: String?
    var endScheduledTime: String?
    var instructions: String?

    var quantitySchedule: String?
    var quantityValue: String?
    var quantityInstructions: String?

    var repeatFrequency: String?

    var imageURLs: [String]?

    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case code
        case title
        case description
        case kidID
        case activityName
        case scheduledTime
        case endScheduledTime
        case instructions
        case quantitySchedule
        case quantityValue
        case quantityInstructions
        case repeatFrequency
        case imageURLs
        case createdAt
        case updatedAt
    }
    
    // MARK: - Computed Properties
    var timeRangeDisplay: String {
        guard let scheduledTime = scheduledTime else {
            return "No time scheduled"
        }
        
        if let endScheduledTime = endScheduledTime {
            return "\(scheduledTime) - \(endScheduledTime)"
        } else {
            return scheduledTime
        }
    }
}
