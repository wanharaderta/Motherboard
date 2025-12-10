//
//  BaseViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import Foundation
import Observation

// Mark: - Base View Model
@Observable
@MainActor
class BaseViewModel {
    
    var isLoading: Bool = false
    var isError: Bool = false
    var isSuccess: Bool = false
    var errorMessage: String?
    
    // Helper method to handle loading states and errors
    @MainActor
    func withLoading<T>(_ action: () async throws -> T) async -> T? {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        do {
            return try await action()
        } catch {
            //self.isError = error
            self.isError = true
            return nil
        }
    }
    
    func showError(message: String) {
        errorMessage = message
        isError = true
    }
    
    func clearError() {
        errorMessage = nil
        isError = false
    }
}
