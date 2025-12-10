//
//  MainScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import SwiftUI
import Combine

struct MainScreenView: View {
    @AppStorage(Enums.hasCompletedOnboarding.rawValue) private var hasCompletedOnboarding: Bool = false
    @State private var showSplash = true
    @StateObject private var authManager = AuthManager.shared
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack {
            Group {
                if hasCompletedOnboarding {
                    if authManager.isLoggedIn {
                        HomeScreenView()
                    } else {
                        LoginScreenView()
                    }
                } else if showSplash {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showSplash = false
                            }
                        }
                } else {
                    OnBoardingScreenView()
                }
            }
        }
        .onAppear {
            setupNotificationObserver()
        }
    }
}

// MARK: - Notification Handling Extension
extension MainScreenView {
    private func setupNotificationObserver() {
        NotificationManager.shared.publisher(for: .didLogin)
            .receive(on: DispatchQueue.main)
            .sink { notification in
                handleLoginSuccess(notification)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Login Success Handler
    private func handleLoginSuccess(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isLogin = userInfo[AppNotificationKey.isLogin.rawValue] as? Bool,
              isLogin else { return }
        
        print("   Login successful - Navigating to Home...")
    }
}

#Preview {
    MainScreenView()
}
