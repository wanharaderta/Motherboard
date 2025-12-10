//
//  LoginViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import Foundation

@MainActor
@Observable
class LoginViewModel: BaseViewModel {
    
    // MARK: - Properties
    var email: String = ""
    var password: String = ""
    
    // MARK: - Methods
    
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
    
    /// Validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
