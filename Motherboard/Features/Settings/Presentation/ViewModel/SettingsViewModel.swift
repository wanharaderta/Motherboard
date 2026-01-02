//
//  SettingsViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

import Foundation

@MainActor
@Observable
final class SettingsViewModel: BaseViewModel {
    
    // MARK: - Search
    var searchText: String = ""
    
    // MARK: - Toggle States
    var completedRoutineToggle: Bool = true
    var lateRoutineToggle: Bool = false
    var delayedRoutineToggle: Bool = true
    var enableFaceIDToggle: Bool = false
    
    // MARK: - All Settings Items
    var allSettingsItems: [SettingsItemModel] {
        var items: [SettingsItemModel] = []
        
        // Account and Access Management
        items.append(SettingsItemModel(
            id: "account_settings",
            section: .accountAndAccess,
            title: Constants.accountSettings,
            icon: "icProfile",
            type: .navigation
        ))
        items.append(SettingsItemModel(
            id: "children",
            section: .accountAndAccess,
            title: Constants.children,
            icon: "icBaby",
            type: .navigation
        ))
        items.append(SettingsItemModel(
            id: "caregivers",
            section: .accountAndAccess,
            title: Constants.caregivers,
            icon: "icPersonHome",
            type: .navigation
        ))
        items.append(SettingsItemModel(
            id: "subscriptions",
            section: .accountAndAccess,
            title: Constants.subscriptions,
            icon: "icSubscription",
            type: .navigation
        ))
        
        // App Mode
        items.append(SettingsItemModel(
            id: "caregiver_mode",
            section: .appMode,
            title: Constants.caregiverMode,
            icon: "icSwap",
            type: .navigation
        ))
        
        // Notifications
        items.append(SettingsItemModel(
            id: "completed_routine",
            section: .notifications,
            title: Constants.completedRoutine,
            icon: "icBell",
            type: .toggle
        ))
        items.append(SettingsItemModel(
            id: "late_routine",
            section: .notifications,
            title: Constants.lateRoutine,
            icon: "icClockAlert",
            type: .toggle
        ))
        items.append(SettingsItemModel(
            id: "delayed_routine",
            section: .notifications,
            title: Constants.delayedRoutine,
            icon: "icSnooze",
            type: .toggle
        ))
        
        return items
    }
    
    // MARK: - Filtered Settings Items
    var filteredSettingsItems: [SettingsItemModel] {
        if searchText.isEmpty {
            return allSettingsItems
        } else {
            return allSettingsItems.filter { item in
                item.searchableText.contains(searchText.lowercased())
            }
        }
    }
    
    // MARK: - Grouped Settings Items
    var groupedSettingsItems: [SettingsSection: [SettingsItemModel]] {
        Dictionary(grouping: filteredSettingsItems) { $0.section }
    }
    
    // MARK: - Toggle Helper
    func getToggleValue(for itemId: String) -> Bool {
        switch itemId {
        case "completed_routine":
            return completedRoutineToggle
        case "late_routine":
            return lateRoutineToggle
        case "delayed_routine":
            return delayedRoutineToggle
        case "enable_face_id":
            return enableFaceIDToggle
        default:
            return false
        }
    }
    
    func setToggleValue(for itemId: String, value: Bool) {
        switch itemId {
        case "completed_routine":
            completedRoutineToggle = value
        case "late_routine":
            lateRoutineToggle = value
        case "delayed_routine":
            delayedRoutineToggle = value
        case "enable_face_id":
            enableFaceIDToggle = value
        default:
            break
        }
    }
}
