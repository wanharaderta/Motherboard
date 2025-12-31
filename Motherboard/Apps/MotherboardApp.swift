//
//  MotherboardApp.swift
//  Motherboard
//
//  Created by Wanhar on 25/11/25.
//

import SwiftUI
import GoogleSignIn

@main
struct MotherboardApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .onAppear {
                    // Setup auth state listener on app launch
                    AuthManager.shared.fethcUserData()
                }
                .onOpenURL { url in
                    // Handle URL opening for Google Sign In
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
