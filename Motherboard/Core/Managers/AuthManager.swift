//
//  AuthManager.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class AuthManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = AuthManager()
    
    // MARK: - Properties
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var userData: UserModelResponse?
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var userListener: ListenerRegistration?
    private let userRepository: UserRepository = UserRepositoryImpl()
    
    // MARK: - Auth State Listener
    func fethcUserData() {
        // Remove existing listener if any
        if let existingListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(existingListener)
        }
        
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                guard let self = self else { return }
                self.currentUser = user
                let wasLoggedIn = self.isLoggedIn
                self.isLoggedIn = user != nil
                
                if self.isLoggedIn != wasLoggedIn {
                    print("🔄 AuthManager: isLoggedIn changed from \(wasLoggedIn) to \(self.isLoggedIn)")
                }
                
                // Remove existing user listener
                self.userListener?.remove()
                self.userListener = nil
                
                // Setup user data listener when user logs in
                if let userID = user?.uid {
                    self.setupUserDataListener(userID: userID)
                } else {
                    self.userData = nil
                }
            }
        }
    }
    
    // MARK: - User Data Listener
    private func setupUserDataListener(userID: String) {
        userListener = userRepository.listenToUserByID(userID: userID) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let userData):
                    self?.userData = userData
                case .failure(let error):
                    print("❌ Error listening to user data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
        userListener?.remove()
    }
    
    // MARK: - Authentication Methods
    
    /// Sign in with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated user
    /// - Throws: AuthError if sign in fails
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    /// Create new account with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Newly created user
    /// - Throws: AuthError if registration fails
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    /// Sign out current user
    func signOut() throws {
        userListener?.remove()
        userListener = nil
        try Auth.auth().signOut()
    }
    
    /// Send password reset email
    /// - Parameter email: User's email address
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    /// Confirm password reset with action code
    /// - Parameters:
    ///   - oobCode: The action code from the password reset email
    ///   - newPassword: The new password
    /// - Throws: AuthError if confirmation fails
    func confirmPasswordReset(oobCode: String, newPassword: String) async throws {
        try await Auth.auth().confirmPasswordReset(withCode: oobCode, newPassword: newPassword)
    }
    
    /// Get current user ID (convenience property)
    var currentUserID: String? {
        currentUser?.uid
    }
}
