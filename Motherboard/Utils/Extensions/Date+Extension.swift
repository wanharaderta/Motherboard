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
    
    /// Format date to MM/dd/yyyy string format
    /// - Returns: Formatted date string (e.g., "12/25/2025")
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
    
    /// Parse date string from MM/dd/yyyy format to Date
    /// - Parameter dateString: Date string in MM/dd/yyyy format
    /// - Returns: Date object if parsing succeeds, nil otherwise
    static func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: dateString)
    }
}
