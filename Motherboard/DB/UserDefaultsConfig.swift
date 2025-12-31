//
//  UserDefaultsConfig.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserDefaultsConfig {
    // MARK: - Keys
    private static let selectedKidIDKey = "selectedKidID"
    private static let currentUserIDKey = "currentUserID"
    
    // MARK: - Properties
    
    @UserDefault(selectedKidIDKey, defaultValue: "")
    static var selectedKidID: String
    
    @UserDefault(currentUserIDKey, defaultValue: "")
    static var currentUserID: String
    
    // MARK: - Methods
    static func removeAll() {
        let keys = [
            selectedKidIDKey,
            currentUserIDKey
        ]
        
        let defaults = UserDefaults.standard
        keys.forEach { defaults.removeObject(forKey: $0) }
    }
}
