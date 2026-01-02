//
//  SettingsItem.swift
//  Motherboard
//
//  Created by Cursor on 02/01/26.
//

import Foundation
import SwiftUI

enum SettingsSection: String, Identifiable {
    case accountAndAccess = "Account and Access Management"
    case appMode = "App Mode"
    case notifications = "Notifications"
    
    var id: String { rawValue }
}

enum SettingsItemType {
    case navigation
    case toggle
}

struct SettingsItemModel: Identifiable, Hashable {
    let id: String
    let section: SettingsSection
    let title: String
    let icon: String
    let type: SettingsItemType
    
    var searchableText: String {
        return "\(section.rawValue) \(title)".lowercased()
    }
    
    static func == (lhs: SettingsItemModel, rhs: SettingsItemModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

