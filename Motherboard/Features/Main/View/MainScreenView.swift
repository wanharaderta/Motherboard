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
    @AppStorage(Enums.hasCompletedOnboarding.rawValue) private var hasCompletedOnboarding: Bool = false
    @State private var showSplash = true
    @StateObject private var authManager = AuthManager.shared
    @State private var cancellables = Set<AnyCancellable>()
    @State private var navigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.navigationPath) {
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
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    OnBoardingScreenView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .splash:
                    SplashScreenView()
                case .onboarding:
                    OnBoardingScreenView()
                case .register:
                    RegisterScreenView()
                case .login:
                    LoginScreenView()
                case .home:
                    HomeScreenView()
                }
            }
        }
        .onAppear {
            authManager.fethcUserData()
            setupNotificationObserver()
        }
        .environment(navigationCoordinator)
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
        authManager.fethcUserData()
        hasCompletedOnboarding = true
        showSplash = false
        navigationCoordinator.replace(with: AppRoute.home)
    }
}

#Preview {
    MainScreenView()
}
