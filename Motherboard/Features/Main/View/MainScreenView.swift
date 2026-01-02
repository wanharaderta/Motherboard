//
//  MainScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 26/11/25.
//

import SwiftUI
import Combine
import Observation

struct MainScreenView: View {
    
    // MARK: - Properties
    
    // App Storage
    @AppStorage(Enums.hasCompletedOnboarding.rawValue) private var hasCompletedOnboarding: Bool = false
    
    // State
    @State private var showSplash = true
    @ObservedObject private var authManager = AuthManager.shared
    @State private var cancellables = Set<AnyCancellable>()
    @State private var navigationCoordinator = Router()
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.navigationPath) {
            rootContentView
                .navigationDestination(for: MainDestinationsView.self) { route in
                    destinationView(for: route)
                }
        }
        .onAppear {
            authManager.fethcUserData()
            setupNotificationObserver()
        }
        .environment(navigationCoordinator)
    }
    
    // MARK: - Root Content View
    @ViewBuilder
    private var rootContentView: some View {
        if showSplash {
            SplashScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        } else {
            if hasCompletedOnboarding {
                authenticatedContentView
            } else {
                OnBoardingScreenView()
            }
        }
    }
    
    // MARK: - Authenticated Content View
    
    @ViewBuilder
    private var authenticatedContentView: some View {
        if authManager.isLoggedIn {
            MainTabsView()
        } else {
            LoginScreenView()
        }
    }
}

// MARK: - Helpers
extension MainScreenView {
    
    // MARK: - Navigation Destination
    @ViewBuilder
    private func destinationView(for route: MainDestinationsView) -> some View {
        switch route {
        case .splash:
            SplashScreenView()
        case .onboarding:
            OnBoardingScreenView()
        case .register:
            RegisterScreenView()
        case .login:
            LoginScreenView()
        case .forgotPassword:
            ForgotPasswordScreenView()
        case .home:
            HomeScreenView()
        }
    }
    
    // MARK: - Setup Notification Observer
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
              isLogin else {
            return
        }
        
        hasCompletedOnboarding = true
        showSplash = false
        withAnimation {
            navigationCoordinator.replace(with: MainDestinationsView.home)
        }
    }
}

#Preview {
    MainScreenView()
}
