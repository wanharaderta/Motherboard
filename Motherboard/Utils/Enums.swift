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

// MARK: - Plan User
enum PlanType: Int, Codable {
    case free = 0
    case premium = 1
}

// MARK: - Role User
enum UserRoleModel: Int, CaseIterable {
    case parent = 1
    case caregiver = 2
    
    var title: String {
        switch self {
        case .parent:
            return "Parent"
        case .caregiver:
            return "Caregiver"
        }
    }
    
    var description: String {
        switch self {
        case .parent:
            return "Create routines, track care, and manage updates."
        case .caregiver:
            return "Follow routines, log activities, and update parents."
        }
    }
    
    var icon: String {
        switch self {
        case .parent:
            return "coupleWalksWithBaby"
        case .caregiver:
            return "icMotherWalking"
        }
    }
}

// MARK: - Allergy Severity Enum
enum AllergySeverity: Int, Codable, CaseIterable {
    case mild = 0
    case moderate = 1
    case severe = 2
    
    var displayName: String {
        switch self {
        case .mild:
            return "Mild"
        case .moderate:
            return "Moderate"
        case .severe:
            return "Severe"
        }
    }
}

// MARK: - Ongoing Enum
enum Ongoing: Int, Codable, CaseIterable {
    case yes = 0
    case no = 1
    
    var displayName: String {
        switch self {
        case .yes:
            return "Yes"
        case .no:
            return "No"
        }
    }
}

// MARK: - Medication Dose Enum
enum MedicationDose: Int, Codable, CaseIterable {
    case mgML = 0
    case mg = 1
    case mL = 2
    case g = 3
    case units = 4
    
    var displayName: String {
        switch self {
        case .mgML:
            return "mg/mL"
        case .mg:
            return "mg"
        case .mL:
            return "mL"
        case .g:
            return "g"
        case .units:
            return "units"
        }
    }
}

// MARK: - Medication Route Enum
enum MedicationRoute: Int, Codable, CaseIterable {
    case oral = 0
    case intravenous = 1
    case intramuscular = 2
    case subcutaneous = 3
    case topical = 4
    case nasal = 5
    case ophthalmic = 6
    
    var displayName: String {
        switch self {
        case .oral:
            return "Oral"
        case .intravenous:
            return "Intravenous"
        case .intramuscular:
            return "Intramuscular"
        case .subcutaneous:
            return "Subcutaneous"
        case .topical:
            return "Topical"
        case .nasal:
            return "Nasal"
        case .ophthalmic:
            return "Ophthalmic"
        }
    }
}

// MARK: - Medication Frequency Enum
enum MedicationFrequency: Int, Codable, CaseIterable {
    case daily = 0
    case twiceDaily = 1
    case threeTimesDaily = 2
    case fourTimesDaily = 3
    case weekly = 4
    case asNeeded = 5
    
    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .twiceDaily:
            return "Twice Daily"
        case .threeTimesDaily:
            return "Three Times Daily"
        case .fourTimesDaily:
            return "Four Times Daily"
        case .weekly:
            return "Weekly"
        case .asNeeded:
            return "As Needed"
        }
    }
}

// MARK: - Displayable Conformance

extension MedicationDose: Displayable {}
extension MedicationRoute: Displayable {}
extension MedicationFrequency: Displayable {}
extension AllergySeverity: Displayable {}
extension Ongoing: Displayable {}
extension Gender: Displayable {}
