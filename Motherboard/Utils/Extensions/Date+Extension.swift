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
    
    /// Get age as formatted string (e.g., "5 years" or "8 Month Old")
    /// - Returns: Formatted age string
    func ageString() -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month], from: self, to: Date())
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        
        if years == 0 && months > 0 {
            return "\(months) Month Old"
        } else if years > 0 {
            return "\(years) years"
        } else {
            return "Newborn"
        }
    }
    
    /// Get age in months only
    /// - Returns: Age in months as Int
    func ageInMonths() -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month], from: self, to: Date())
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        return (years * 12) + months
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
    
    /// Format time to HH:mma format (e.g., "08:00AM", "02:30PM")
    /// - Returns: Formatted time string
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        return formatter.string(from: self)
    }
}
