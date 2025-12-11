//
//  Enums.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import Foundation

// MARK: - AppStorageConfig Keys
enum Enums: String {
    case hasCompletedOnboarding = "hasCompletedOnboarding"
}

// MARK: - Gender Enum
enum Gender: Int, Codable, CaseIterable {
    case male = 0
    case female = 1
    case other = 2
    
    var displayName: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        }
    }
}

enum PlanType: Int, Codable {
    case free = 0
    case premium = 1
    
    /// Safely create from an arbitrary raw value (defaults to `.free`)
    init(rawValue: Int) {
        self = PlanType(rawValue: rawValue)
    }
}
