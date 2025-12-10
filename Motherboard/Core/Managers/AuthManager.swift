//
//  AuthManager.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import Foundation
import FirebaseAuth
import Combine

final class AuthManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = AuthManager()
    
    // MARK: - Properties
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    private init() {
        // Setup auth state listener
        setupAuthStateListener()
    }
    
    // MARK: - Auth State Listener
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isLoggedIn = user != nil
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Authentication Methods
    
    /// Sign in with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated user
    /// - Throws: AuthError if sign in fails
    func signIn(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
                self.isLoggedIn = true
            }
            return result.user
        } catch {
            throw AuthError.from(error)
        }
    }
    
    /// Create new account with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Newly created user
    /// - Throws: AuthError if registration fails
    func signUp(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
                self.isLoggedIn = true
            }
            return result.user
        } catch {
            throw AuthError.from(error)
        }
    }
    
    /// Sign out current user
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            Task { @MainActor in
                self.currentUser = nil
                self.isLoggedIn = false
            }
        } catch {
            throw AuthError.from(error)
        }
    }
    
    /// Send password reset email
    /// - Parameter email: User's email address
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.from(error)
        }
    }
    
    /// Get current user ID (convenience property)
    var currentUserID: String? {
        currentUser?.uid
    }
}
