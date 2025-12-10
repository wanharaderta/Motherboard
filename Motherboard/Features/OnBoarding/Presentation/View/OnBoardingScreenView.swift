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
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                header
                content
                footer
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
    
    private var header: some View {
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
    
    private var content: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<totalPages, id: \.self) { index in
                OnboardingPageView(page: viewModel.onboardingPages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentPage)
    }
    
    private var footer: some View {
        ZStack {
            PaginationIndicatorView(
                totalPages: totalPages,
                currentPage: currentPage,
                activeColor: Color.grey500,
                inactiveColor: Color.green200
            )
            
            if !isLastPage {
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
                    //    completeOnboarding()
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

                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text(Constants.alreadyHaveAnAccount)
                            .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
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
}

#Preview {
    OnBoardingScreenView()
}
