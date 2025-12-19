//
//  AuthViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 19/12/25.
//

import Foundation
import FirebaseAuth

@MainActor
@Observable
class AuthViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    // Login & Forgot Password
    var email: String = ""
    var password: String = ""
    
    // Register
    var fullName: String = ""
    var confirmPassword: String = ""
    
    private let userRepository: UserRepository = UserRepositoryImpl()
    
    // MARK: - Login Methods
    
    /// Sign in with email and password
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = Constants.fillAllFields
            isError = true
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = Constants.validEmail
            isError = true
            return
        }
        
        errorMessage = nil
        isError = false
        
        await withLoading {
            do {
                _ = try await AuthManager.shared.signIn(email: email, password: password)
                isSuccess = true
                
                // Send login success notification using NotificationManager
                NotificationManager.shared.post(
                    .didLogin,
                    userInfo: [AppNotificationKey.isLogin.rawValue: true]
                )
                
                print("✅ Login successful")
            } catch {
                let authError = AuthError.from(error)
                errorMessage = authError.errorDescription
                isError = true
                print("❌ Error login: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Register Methods
    
    /// Register with email and password
    func signUpWithEmail() async {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = Constants.fillAllFields
            isError = true
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = Constants.validEmail
            isError = true
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = Constants.passwordTooShort
            isError = true
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = Constants.passwordDoNotMatch
            isError = true
            return
        }
        
        errorMessage = nil
        isError = false
        
        await withLoading {
            do {
                let user = try await AuthManager.shared.signUp(email: email, password: password)
                try await saveUserDocument(for: user)
                isSuccess = true
                
                // Send login success notification using NotificationManager
                NotificationManager.shared.post(
                    .didLogin,
                    userInfo: [AppNotificationKey.isLogin.rawValue: true]
                )
                
                print("✅ Registration successful")
            } catch {
                let authError = AuthError.from(error)
                errorMessage = authError.errorDescription
                isError = true
                print("❌ Error registration: \(error.localizedDescription)")
            }
        }
    }
    
    /// Register with Google
    func signUpWithGoogle() async {
        errorMessage = nil
        isError = false
        
        await withLoading {
            do {
                let user = try await GoogleAuth.signIn()
                try await saveUserDocument(for: user)
                isSuccess = true
                
                NotificationManager.shared.post(
                    .didLogin,
                    userInfo: [AppNotificationKey.isLogin.rawValue: true]
                )
                
                print("✅ Google registration successful")
            } catch {
                let authError = AuthError.from(error)
                errorMessage = authError.errorDescription
                isError = true
                print("❌ Error registration via Google: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Forgot Password Methods
    
    /// Send password reset email
    func resetPassword() async {
        guard !email.isEmpty else {
            errorMessage = Constants.fillAllFields
            isError = true
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = Constants.validEmail
            isError = true
            return
        }
        
        errorMessage = nil
        isError = false
        
        await withLoading {
            do {
                try await AuthManager.shared.resetPassword(email: email)
                isSuccess = true
                print("✅ Password reset email sent successfully")
            } catch {
                let authError = AuthError.from(error)
                errorMessage = authError.errorDescription
                isError = true
                print("❌ Error sending password reset: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Helpers
extension AuthViewModel {
    /// Persist user profile to Firestore via repository
    private func saveUserDocument(for user: User) async throws {
        guard let uid = user.uid as String?, !uid.isEmpty,
              let request = buildUserRequest(from: user) else {
            throw NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user data"])
        }
        try await userRepository.addUser(userID: uid, user: request)
    }
    
    /// Build request payload from Firebase User and local fields
    private func buildUserRequest(from user: User) -> UserModelRequest? {
        let emailValue = user.email ?? email
        guard !emailValue.isEmpty else { return nil }
        
        let nameCandidate = user.displayName ?? fullName
        let nameValue = nameCandidate.isEmpty ? emailValue : nameCandidate
        
        return UserModelRequest(
            name: nameValue,
            email: emailValue,
            planType: .free,
            maxKids: 0,
            roleCaregiver: false,
            roleParent: true,
            createdAt: Date(),
            updatedAt: Date(),
            isFillOnboardingData: false
        )
    }
    
    /// Validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
