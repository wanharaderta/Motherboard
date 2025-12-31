//
//  HomeViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import Foundation
import FirebaseFirestore

@MainActor
@Observable
class HomeViewModel: BaseViewModel {
    
    // MARK: - Properties
    var kids: [KidsModelResponse] = []
    var todaySchedule: ScheduleItem?
    var upcomingItems: [UpcomingItem] = []
    var greeting: String {
        getGreeting()
    }
    
    // New properties for home screen
    var selectedKid: KidsModelResponse? {
        kids.first
    }
    
    var routineProgress: Double = 0.90 // 90%
    var totalRoutines: Int = 10
    var remainingRoutines: Int = 1
    
    var selectedRoutineCategory: RoutineCategory = .mealsAndBottles
    
    var upcomingRoutines: [UpcomingRoutine] = [
        UpcomingRoutine(
            icon: "icImagePlayingWithDolls",
            timeRange: "07:00 - 09:00AM",
            description: "Sonia's having a short nap",
            routineType: .mealsAndBottles
        ),
        UpcomingRoutine(
            icon: "icBabyBottle",
            timeRange: "09:30 - 10:00AM",
            description: "Sonia's light morning breakfast",
            routineType: .mealsAndBottles
        ),
        UpcomingRoutine(
            icon: "icPharma",
            timeRange: "12:00 - 12:10PM",
            description: "Sonia's medication as prescribed",
            routineType: .medication
        ),
        UpcomingRoutine(
            icon: "icBabyBottle",
            timeRange: "01:00 - 01:30PM",
            description: "Sonia's launch",
            routineType: .mealsAndBottles
        ),
        UpcomingRoutine(
            icon: "icNappy",
            timeRange: "02:30 - 03:00PM",
            description: "Sonia's diapers replacement",
            routineType: .diaper
        )
    ]
    
    // MARK: - Dependencies
    private let kidsRepository: KidsRepository = KidsRepositoryImpl()
    private var kidsListener: ListenerRegistration?
    
    // MARK: - Methods
    func loadData() {
        guard let userID = AuthManager.shared.currentUserID else {
            print("❌ No user ID available")
            return
        }
        
        // Listen to kids data
        kidsListener = kidsRepository.listenToKids(
            userID: userID
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let kidsData):
                self.kids = kidsData
                print("✅ Kids loaded: \(kidsData.count) items")
                
                // Update today's schedule if kids available
                if let firstKid = kidsData.first {
                    self.updateTodaySchedule(with: firstKid)
                }
                
            case .failure(let error):
                print("❌ Error loading kids: \(error.localizedDescription)")
                self.isError = true
            }
        }
        
        // Sample data for other sections
        upcomingItems = [
            UpcomingItem(title: "School pick-up", value: "30")
        ]
    }
    
    private func updateTodaySchedule(with kid: KidsModelResponse) {
        // Calculate age from date of birth
        todaySchedule = ScheduleItem(
            kidName: kid.fullname,
            kidAge: kid.dob.ageString(),
            time: "3:00 PM", // This should come from schedule data
            photoUrl: kid.photoUrl
        )
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
    func shareSitterSheet() {
        // Implement share functionality
    }
    
    func addKid() {
        // TODO: Navigate to add kids screen or show add kids form
        print("Add kid button tapped")
    }
    
    func removeListener() {
        kidsListener?.remove()
        kidsListener = nil
    }
}

// MARK: - Models
struct ScheduleItem {
    let kidName: String
    let kidAge: String
    let time: String
    let photoUrl: String
}

struct UpcomingItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

// MARK: - Routine Category
enum RoutineCategory: String, CaseIterable {
    case mealsAndBottles = "Meals & Bottles"
    case medication = "Medication"
    case diaper = "Diaper"
    
    var icon: String {
        switch self {
        case .mealsAndBottles:
            return "icBabyBottle"
        case .medication:
            return "icPharma"
        case .diaper:
            return "icNappy"
        }
    }
}

// MARK: - Upcoming Routine
struct UpcomingRoutine: Identifiable {
    let id = UUID()
    let icon: String
    let timeRange: String
    let description: String
    let routineType: RoutineCategory
}
