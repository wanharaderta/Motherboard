//
//  OnboardingHomeFlowScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 12/12/25.
//

import SwiftUI

struct OnboardingHomeFlowScreenView: View {
    @State private var currentPage: Int = 0
    @Environment(\.dismiss) private var dismiss
    
    private let totalPages = 2 // UserRole and AddChild
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBar
                
                // TabView Content
                TabView(selection: $currentPage) {
                    // Page 0: User Role Selection
                    OnboardingUserRoleScreenView(onContinue: {
                        withAnimation {
                            nextPage()
                        }
                    })
                    .tag(0)
                    
                    // Page 1: Add Child
                    OnboardingAddChildScreenView(onContinue: {
                        handleComplete()
                    })
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            if currentPage > 0 {
                Button(action: {
                    withAnimation {
                        previousPage()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.tundora)
                        .font(.system(size: 20, weight: .medium))
                }
            }
            
            Spacer()
            
            if !isLastPage {
                Button(action: {
                    handleSkip()
                }) {
                    Text(Constants.skip)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .foregroundColor(Color.tundora)
                }
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.top, Spacing.m)
        .frame(height: 44)
    }
}

extension OnboardingHomeFlowScreenView {
    // MARK: - Computed Properties
    private var isLastPage: Bool {
        currentPage >= totalPages - 1
    }
    
    // MARK: - Methods
    private func nextPage() {
        guard currentPage < totalPages - 1 else { return }
        currentPage += 1
    }
    
    private func previousPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }
    
    private func handleSkip() {
        // Handle skip action - complete onboarding or navigate away
        dismiss()
    }
    
    private func handleComplete() {
        // Handle completion - navigate to next screen or complete onboarding
        dismiss()
    }
}

#Preview {
    NavigationStack {
        OnboardingHomeFlowScreenView()
    }
}
