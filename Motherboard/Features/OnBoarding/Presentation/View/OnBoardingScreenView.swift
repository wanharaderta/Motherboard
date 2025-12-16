//
//  OnBoardingScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 25/11/25.
//

import SwiftUI

struct OnBoardingScreenView: View {
    
    // MARK: - Properties
    @State private var viewModel = OnboardingViewModel()
    @State private var currentPage: Int = 0
    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                headerView
                contentView
                footerView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
        VStack {
            if !isLastPage {
                HStack {
                    Spacer()
                    Button(action: {
                        skipOnboarding()
                    }) {
                        Text(Constants.skip)
                            .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                            .foregroundColor(Color.black)
                    }
                    .padding(.trailing, Spacing.xl)
                }
                .frame(height: Spacing.xxl)
            }
        }
        .frame(height: Spacing.xxl)
    }
    
    private var contentView: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<totalPages, id: \.self) { index in
                OnboardingPageView(page: viewModel.onboardingPages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentPage)
    }
    
    private var footerView: some View {
        ZStack {
            if !isLastPage {
                PaginationIndicatorView(
                    totalPages: totalPages,
                    currentPage: currentPage,
                    activeColor: Color.grey500,
                    inactiveColor: Color.green200
                )
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            nextPage()
                        }
                    }) {
                        Text(Constants.next)
                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                            .foregroundColor(Color.grey500)
                    }
                    .padding(.trailing, Spacing.xl)
                }
            } else {
                VStack(spacing: Spacing.l) {
                    Button(action: {
                        startRegistration()
                    }) {
                        Text(Constants.getStarted)
                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.primaryGreen900)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, Spacing.xl)
                    
                    HStack(spacing: Spacing.xxs) {
                        Spacer()
                        Text(Constants.alreadyHaveAnAccount)
                            .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                            .foregroundColor(Color.mineShaftOpacity86)
                        
                        Button(action: {
                            completeOnboarding()
                        }) {
                            Text(Constants.logIn)
                                .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                                .foregroundColor(Color.primaryGreen900)
                        }
                        Spacer()
                    }
                    .padding(.bottom, Spacing.xl)
                }
            }
        }
        .frame(height: Spacing.sp100)
    }
}

// MARK: - Logic
extension OnBoardingScreenView {
    var isLastPage: Bool {
        currentPage >= viewModel.onboardingPages.count - 1
    }
    
    var totalPages: Int {
        viewModel.onboardingPages.count
    }
    
    // MARK: - Methods
    
    /// Navigate to next page
    func nextPage() {
        guard currentPage < viewModel.onboardingPages.count - 1 else { return }
        currentPage += 1
    }
    
    /// Skip onboarding and complete it
    func skipOnboarding() {
        UserDefaults.standard.set(true, forKey: Enums.hasCompletedOnboarding.rawValue)
    }
    
    /// Complete onboarding
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: Enums.hasCompletedOnboarding.rawValue)
    }
    
    /// Navigate to register screen
    func startRegistration() {
        navigationCoordinator.navigate(to: AppRoute.register)
    }
}

#Preview {
    OnBoardingScreenView()
}
