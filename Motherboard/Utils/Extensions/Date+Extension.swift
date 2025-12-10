//
//  Date+Extension.swift
//  Motherboard
//
//  Created by Wanhar on 29/11/25.
//

import Foundation

extension Date {
    
    /// Calculate age in years from this date to now
    /// - Returns: Age in years as Int
    func calculateAge() -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year ?? 0
    }
    
    /// Get age as formatted string (e.g., "5 years")
    /// - Returns: Formatted age string
    func ageString() -> String {
        let years = calculateAge()
        return "\(years) years"
    }
}
