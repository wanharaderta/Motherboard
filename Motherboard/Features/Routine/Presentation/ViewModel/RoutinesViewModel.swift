//
//  RoutinesViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

import Foundation
import UIKit
import FirebaseFirestore

@MainActor
@Observable
final class RoutinesViewModel: BaseViewModel {
    
    // MARK: - Properties
    var routines: [RoutinesModelResponse] = []
    
    // MARK: - Dependencies
    private let repository: RoutinesRepository = RoutinesRepositoryImpl()
    private let authManager = AuthManager.shared
    private var routinesListener: ListenerRegistration?
    
    // MARK: - Methods
    func fetchRoutines() {
        guard let userID = authManager.currentUserID else {
            print("❌ No user ID available")
            return
        }
        
        // Listen to routines data
        routinesListener = repository.listenToRoutines(
            userID: userID
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let routinesData):
                self.routines = routinesData
                print("✅ Routines loaded: \(routinesData.count) items")
                
            case .failure(let error):
                print("❌ Error loading routines: \(error.localizedDescription)")
                self.isError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func removeListener() {
        routinesListener?.remove()
        routinesListener = nil
    }
}
