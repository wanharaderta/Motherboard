//
//  RoutineModelRequest.swift
//  Motherboard
//
//  Created by Wanhar on 18/12/25.
//
//

import Foundation

struct RoutineModelRequest: Codable {
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
    var intervalHours: Int?

    var imageURLs: [String]?

    var createdAt: Date?
    var updatedAt: Date?
}
