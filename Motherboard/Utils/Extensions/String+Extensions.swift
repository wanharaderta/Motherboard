//
//  String+Extensions.swift
//  Motherboard
//
//  Created by Wanhar on 29/11/25.
//

import Foundation
import FirebaseStorage

extension String {
    
    /// Converts a gs:// Firebase Storage URL to a download URL
    /// - Returns: The download URL as a String, or nil if conversion fails
    func toFirebaseDownloadURL() async -> String? {
        guard self.hasPrefix("gs://") else {
            // If it's already a download URL, return as is
            return self
        }
        
        do {
            return try await StorageManager.shared.getDownloadURL(from: self)
        } catch {
            print("❌ Failed to convert gs:// URL to download URL: \(error.localizedDescription)")
            return nil
        }
    }
}
