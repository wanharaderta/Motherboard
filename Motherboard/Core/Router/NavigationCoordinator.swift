//
//  NavigationCoordinator.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import SwiftUI
import Observation

@Observable
@MainActor
class NavigationCoordinator {
    var navigationPath = NavigationPath()
    
    /// Navigate to a specific route
    func navigate<T: Hashable>(to route: T) {
        navigationPath.append(route)
    }
    
    /// Replace navigation path with a new route (clears history)
    func replace<T: Hashable>(with route: T) {
        navigationPath = NavigationPath()
        navigationPath.append(route)
    }
    
    /// Pop back one level
    func pop() {
        guard !navigationPath.isEmpty else { return }
        var newPath = navigationPath
        newPath.removeLast()
        navigationPath = newPath
    }
    
    /// Pop back to root (clear all navigation)
    func popToRoot() {
        guard !navigationPath.isEmpty else { return }
        navigationPath = NavigationPath()
    }
    
    /// Pop to a specific route (removes all routes after the target route)
    /// Note: This implementation pops to root and navigates to target route
    /// For more complex scenarios, you may need to track path history
    func popTo<T: Hashable>(_ targetRoute: T) {
        popToRoot()
        navigate(to: targetRoute)
    }
    
    /// Pop multiple levels
    func pop(count: Int) {
        let popCount = min(count, navigationPath.count)
        guard popCount > 0 else { return }
        var newPath = navigationPath
        newPath.removeLast(popCount)
        navigationPath = newPath
    }
    
    /// Check if navigation path is empty
    var isEmpty: Bool {
        navigationPath.isEmpty
    }
    
    /// Get the count of items in navigation path
    var count: Int {
        navigationPath.count
    }
}

