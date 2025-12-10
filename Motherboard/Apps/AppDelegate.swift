//
//  AppDelegate.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import SDWebImage

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        // Configure SDWebImage
        configureSDWebImage()
        
        return true
    }
    
    // MARK: - SDWebImage Configuration
    private func configureSDWebImage() {
        // Configure cache
        SDImageCache.shared.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB
        SDImageCache.shared.config.maxDiskAge = 3600 * 24 * 7 // 7 days
        
        // Configure downloader
        SDWebImageDownloader.shared.config.maxConcurrentDownloads = 6
        SDWebImageDownloader.shared.config.downloadTimeout = 15.0
        
        // Allow loading from Firebase Storage URLs
        SDWebImageDownloader.shared.config.urlCredential = nil
    }
}
