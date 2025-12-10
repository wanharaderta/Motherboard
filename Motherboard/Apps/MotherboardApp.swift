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
                .onOpenURL { url in
                    // Handle URL opening for Google Sign In
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
