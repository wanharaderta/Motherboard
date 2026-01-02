//
//  Enums.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import Foundation
import SwiftUI

// MARK: - AppStorageConfig Keys
enum Enums: String {
    case hasCompletedOnboarding = "hasCompletedOnboarding"
    case hasCompletedInitialData = "hasCompletedInitialData"
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
enum AllergySeverity: String, Codable, CaseIterable {
    case mild
    case moderate
    case severe
    
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
enum MedicationDose: String, Codable, CaseIterable {
    case mgML = "mg_ml"
    case mg = "mg"
    case mL = "ml"
    case g = "g"
    case units = "units"
    
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
enum MedicationRoute: String, Codable, CaseIterable {
    case oral
    case intravenous
    case intramuscular
    case subcutaneous
    case topical
    case nasal
    case ophthalmic
    
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
enum MedicationFrequency: String, Codable, CaseIterable {
    case daily = "daily"
    case twiceDaily = "twice_daily"
    case threeTimesDaily = "three_times_daily"
    case fourTimesDaily = "four_times_daily"
    case weekly  = "weekly"
    case asNeeded = "as_needed"
    
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

enum RoutineType: String, CaseIterable, Identifiable {
    case bottlesAndMeals
    case medications
    case diapers
    case breastfeedingAndPumping
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .bottlesAndMeals:
            return Constants.bottlesAndMeals
        case .medications:
            return Constants.medications
        case .diapers:
            return Constants.diapers
        case .breastfeedingAndPumping:
            return Constants.breastfeedingAndPumping
        }
    }
    
    var code: String {
        switch self {
        case .bottlesAndMeals:
            return "bottles_meals"
        case .medications:
            return "medications"
        case .diapers:
            return "diapers"
        case .breastfeedingAndPumping:
            return "breastfeeding_pumping"
        }
    }
    
    var description: String {
        switch self {
        case .bottlesAndMeals:
            return Constants.bottlesAndMealsDescription
        case .medications:
            return Constants.medicationsRoutineDescription
        case .diapers:
            return Constants.diapersDescription
        case .breastfeedingAndPumping:
            return Constants.breastfeedingAndPumpingDescription
        }
    }
    
    var iconName: String {
        switch self {
        case .bottlesAndMeals:
            return "icBabyBottle"
        case .medications:
            return "icPharma"
        case .diapers:
            return "icNappy"
        case .breastfeedingAndPumping:
            return "icPersonWomen"
        }
    }
    
    var iconBackgroundColor: Color {
        switch self {
        case .bottlesAndMeals:
            return Color.bgPampas
        case .medications:
            return Color.bgPastelPink
        case .diapers:
            return Color.bgBlueChalk
        case .breastfeedingAndPumping:
            return Color.bgCherub
        }
    }
}

enum MealName: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
}

// MARK: - Default Time Enum (Reusable for Meal and Bottle)
enum DefaultTime: String, CaseIterable {
    case eightAM = "08:00AM"
    case nineAM = "09:00AM"
    case tenAM = "10:00AM"
    
    var firebaseValue: String {
        switch self {
        case .eightAM:
            return "08:00"
        case .nineAM:
            return "09:00"
        case .tenAM:
            return "10:00"
        }
    }
}

// MARK: - Default Ounces Enum
enum DefaultOunces: String, CaseIterable, Hashable {
    case fiftyML = "50mL (1.7 Oz)"
    case threeFiftyML = "350mL (12 Oz)"
}

// MARK: - Repeat Frequency Enum
enum RepeatFrequency: String, CaseIterable {
    case everyDay = "Every day"
    case weekdaysOnly = "Weekdays Only"
    case weekendsOnly = "Weekends Only"
    case customDay = "+ Custom days"
    
    var displayName: String {
        return rawValue
    }
}

// MARK: - Time Interval Enum
enum TimeInterval: String, CaseIterable, Hashable, Displayable {
    case every1Hour = "Every 1 hour interval"
    case every2Hours = "Every 2 hours interval"
    case every4Hours = "Every 4 hours interval"
    case every6Hours = "Every 6 hours interval"
    case every8Hours = "Every 8 hours interval"
    case every12Hours = "Every 12 hours interval"
    
    var displayName: String {
        return rawValue
    }
    
    var code: Int {
        switch self {
        case .every1Hour:
            return 1
        case .every2Hours:
            return 2
        case .every4Hours:
            return 4
        case .every6Hours:
            return 6
        case .every8Hours:
            return 8
        case .every12Hours:
            return 12
        }
    }
}

// MARK: - Week Day Enum
enum WeekDay: String, CaseIterable, Identifiable, Hashable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var id: String { rawValue }
}

// MARK: - Time Item
enum TimeItem: Identifiable, Hashable {
    case defaultTime(DefaultTime)
    case customTime(String)
    
    var id: String {
        switch self {
        case .defaultTime(let time):
            return time.rawValue
        case .customTime(let timeString):
            return timeString
        }
    }
    
    var displayName: String {
        switch self {
        case .defaultTime(let time):
            return time.rawValue
        case .customTime(let timeString):
            return timeString
        }
    }
    
    var firebaseValue: String {
        switch self {
        case .defaultTime(let time):
            return time.firebaseValue
        case .customTime(let timeString):
            // Convert "08:00AM" format to "08:00" for Firebase
            return timeString.replacingOccurrences(of: "AM", with: "")
                .replacingOccurrences(of: "PM", with: "")
        }
    }
}

// MARK: - Diapers Type
enum DiapersType: String, CaseIterable {
    case wet = "Wet"
    case bm = "BM"
    case mixed = "Mixed"
    
    var id: String { rawValue }
}

// MARK: - Diapers Type
enum BreastType: String, CaseIterable {
    case right = "Right"
    case left = "Left"
    
    var id: String { rawValue }
}

// MARK: - Label Field (Reusable for all pages)
enum LabelField: Hashable {
    // Common fields
    case name
    case title
    case routineTitle
    case description
    case notes
    case email
    case password
    case confirmPassword
    case newPassword
    
    // Medications
    case medicationName
    case dose
    case route
    case frequency
    case timeSchedule
    case startDate
    case endDate
    case doctorsNote
    
    // Routines (Meals & Bottles, Diapers)
    case feedingInstructions
    case bottlingInstructions
    case customOunces
    
    // Child/User
    case childsName
    case fullname
    case fullName
    case nickname
    case dateOfBirth
    case gender
    
    // Allergies
    case allergyName
    case severity
    case triggerDetails
    case reactionDescription
    case specificInstructions
    
    // Medical Information
    case conditionName
    case doctorsInstructions
    case doctorName
    case practiceName
    case phone
    case address
    case portalLink
    
    // Emergency Medication
    case autoInjectorBrand
    case whenToAdminister
    
    // Other
    case none
}

// MARK: - Displayable Conformance
extension MedicationDose: Displayable {}
extension MedicationRoute: Displayable {}
extension MedicationFrequency: Displayable {}
extension RepeatFrequency: Displayable {}
extension AllergySeverity: Displayable {}
extension Ongoing: Displayable {}
extension Gender: Displayable {}
