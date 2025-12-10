//
//  StorageManager.swift
//  Motherboard
//
//  Created by Wanhar on 30/11/25.
//

import Foundation
import FirebaseStorage
import UIKit
import FirebaseCore

@MainActor
final class StorageManager {
    
    // MARK: - Singleton
    static let shared = StorageManager()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Storage Bucket
    var storageBucket: String {
        // Get from Firebase Storage app options
        if let bucket = Storage.storage().app.options.storageBucket {
            print("✅ Storage bucket: \(bucket)")
            return bucket
        }
        // Fallback to default bucket from GoogleService-Info.plist
        let defaultBucket = "motherboard-6d4ba.firebasestorage.app"
        print("⚠️ Using default storage bucket: \(defaultBucket)")
        return defaultBucket
    }
    
    func getGSURL(for path: String) -> String {
        let gsURL = "gs://\(storageBucket)/\(path)"
        print("📦 Generated gs:// URL: \(gsURL)")
        return gsURL
    }
    
    // MARK: - Upload Image
    func uploadImage(
        image: UIImage,
        path: String,
        fileName: String? = nil,
        compressionQuality: CGFloat = 0.8
    ) async throws -> String {
        
        // Convert UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            throw StorageError.failedToConvertImage
        }
        
        // Generate file name if not provided
        let finalFileName = fileName ?? "\(UUID().uuidString).jpg"
        
        // Create storage reference
        let storageRef = Storage.storage().reference().child("\(path)\(finalFileName)")
        
        // Set metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the image
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StorageMetadata, Error>) in
            storageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let metadata = metadata {
                    continuation.resume(returning: metadata)
                } else {
                    continuation.resume(throwing: StorageError.unknownUploadError)
                }
            }
        }
        
        // Return gs:// reference URL instead of download URL
        // Format: gs://bucket/path/to/file.jpg
        let fullPath = "\(path)\(finalFileName)"
        let gsURL = getGSURL(for: fullPath)
        
        return gsURL
    }
    
    // MARK: - Get Download URL from gs:// Reference
    func getDownloadURL(from gsURL: String) async throws -> String {
        print("🔄 Converting gs:// URL to download URL: \(gsURL)")
        
        // Create storage reference from gs:// URL
        let storageRef = Storage.storage().reference(forURL: gsURL)
        
        // Get the download URL
        let url = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("❌ Failed to get download URL: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let url = url {
                    print("✅ Got download URL: \(url.absoluteString)")
                    continuation.resume(returning: url)
                } else {
                    print("❌ Download URL is nil")
                    continuation.resume(throwing: StorageError.failedToGetDownloadURL)
                }
            }
        }
        
        return url.absoluteString
    }
    
    // MARK: - Delete Image
    func deleteImage(url: String) async throws {
        guard let storageURL = URL(string: url) else {
            throw StorageError.invalidURL
        }
        
        let storageRef = Storage.storage().reference(forURL: storageURL.absoluteString)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            storageRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // MARK: - Get Image URL from Path
    func getImageURL(path: String) async throws -> String {
        let storageRef = Storage.storage().reference().child(path)
        
        let url = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            storageRef.downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: StorageError.failedToGetDownloadURL)
                }
            }
        }
        
        return url.absoluteString
    }
}

// MARK: - Storage Errors
enum StorageError: LocalizedError {
    case failedToConvertImage
    case unknownUploadError
    case failedToGetDownloadURL
    case emptyDownloadURL
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .failedToConvertImage:
            return "Failed to convert image to data"
        case .unknownUploadError:
            return "Unknown error occurred during upload"
        case .failedToGetDownloadURL:
            return "Failed to get download URL"
        case .emptyDownloadURL:
            return "Download URL is empty"
        case .invalidURL:
            return "Invalid URL format"
        }
    }
}

