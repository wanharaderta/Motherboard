//
//  AuthError.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import Foundation
import FirebaseAuth

enum AuthError: LocalizedError {
    case invalidEmail
    case userDisabled
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case tooManyRequests
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "The email address is invalid."
        case .userDisabled:
            return "This account has been disabled."
        case .userNotFound:
            return "No account found with this email."
        case .wrongPassword:
            return "Incorrect password."
        case .emailAlreadyInUse:
            return "An account already exists with this email."
        case .weakPassword:
            return "Password is too weak. Please use a stronger password."
        case .networkError:
            return "Network error. Please check your connection."
        case .tooManyRequests:
            return "Too many requests. Please try again later."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    static func from(_ error: Error) -> AuthError {
        let nsError = error as NSError
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail:
                return .invalidEmail
            case .userDisabled:
                return .userDisabled
            case .userNotFound:
                return .userNotFound
            case .wrongPassword:
                return .wrongPassword
            case .emailAlreadyInUse:
                return .emailAlreadyInUse
            case .weakPassword:
                return .weakPassword
            case .networkError:
                return .networkError
            case .tooManyRequests:
                return .tooManyRequests
            default:
                return .unknown(error)
            }
        }
        
        return .unknown(error)
    }
}
