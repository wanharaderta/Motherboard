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
