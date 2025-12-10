////
////  UserDefaultsConfig.swift
////  Motherboard
////
////  Created by Wanhar on 26/11/25.
////
//
//import Foundation
//
//@propertyWrapper
//struct UserDefault<T> {
//    let key: String
//    let defaultValue: T
//
//    init(_ key: String, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//
//    var wrappedValue: T {
//        get {
//            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: key)
//        }
//    }
//}
//
//struct UserDefaultsConfig {
//    // Keys
//    static let hasCompletedOnboardingKey = "hasCompletedOnboarding"
//    
//    @UserDefault(hasCompletedOnboardingKey, defaultValue: false)
//    static var hasCompletedOnboarding: Bool
//    
//    static func removeAll() {
//        let keys = [
//            hasCompletedOnboardingKey
//        ]
//        
//        let defaults = UserDefaults.standard
//        keys.forEach { defaults.removeObject(forKey: $0) }
//    }
//}
