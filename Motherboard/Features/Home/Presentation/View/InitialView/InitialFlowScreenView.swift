////
////  OnboardingHomeFlowScreenView.swift
////  Motherboard
////
////  Created by Wanhar on 12/12/25.
////
//
//import SwiftUI
//
//struct InitialFlowScreenView: View {
//    @State private var currentPage: OnboardingPage = .userRole
//    @Environment(\.dismiss) private var dismiss
//    
//    // MARK: - Onboarding Pages Enum
//    enum OnboardingPage: Int, CaseIterable, Hashable {
//        case userRole = 0
//        case addChild = 1
//        case healthMedicalInfo = 2
//        
//        var isLastPage: Bool {
//            self == OnboardingPage.allCases.last
//        }
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Navigation Bar
//            navigationBar
//            
//            // TabView Content - Disable swipe gestures, only allow button navigation
//            TabView(selection: $currentPage) {
//                ForEach(OnboardingPage.allCases, id: \.self) { page in
//                    pageView(for: page)
//                        .tag(page)
//                        .contentShape(Rectangle())
//                        .simultaneousGesture(
//                            DragGesture(minimumDistance: 10)
//                                .onChanged { value in
//                                    // Block horizontal swipes
//                                    if abs(value.translation.width) > abs(value.translation.height) {
//                                        // Horizontal swipe - prevent TabView from handling it
//                                    }
//                                }
//                        )
//                }
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .animation(.easeInOut, value: currentPage)
//            .edgesIgnoringSafeArea(.bottom)
//            .disableTabViewSwipe()
//        }
//        .background(Color.white.ignoresSafeArea())
//        .navigationBarBackButtonHidden(true)
//    }
//    
//    // MARK: - Navigation Bar
//    private var navigationBar: some View {
//        HStack {
//            if currentPage != .userRole {
//                Button(action: {
//                    withAnimation {
//                        previousPage()
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(Color.tundora)
//                        .font(.system(size: 20, weight: .medium))
//                }
//            }
//            
//            Spacer()
//            
//            if currentPage.isLastPage {
//                Button(action: {
//                    handleSkip()
//                }) {
//                    Text(Constants.skipForNow)
//                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                        .foregroundColor(Color.tundora)
//                }
//            } else {
//                Button(action: {
//                    handleSkip()
//                }) {
//                    Text(Constants.skip)
//                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                        .foregroundColor(Color.tundora)
//                }
//            }
//        }
//        .padding(.horizontal, Spacing.xl)
//        .padding(.top, Spacing.m)
//        .frame(height: 44)
//    }
//}
//
//extension InitialFlowScreenView {
//    // MARK: - Page View Builder
//    @ViewBuilder
//    private func pageView(for page: OnboardingPage) -> some View {
//        switch page {
//        case .userRole:
//            InitialUserRoleScreenView()
//            
//        case .addChild:
//            InitialAddChildScreenView()
//            
//        case .healthMedicalInfo:
//            MainHealthMedicalInfoScreenView(
//                onContinue: {
//                    handleComplete()
//                },
//                onSkip: {
//                    handleSkip()
//                }
//            )
//        }
//    }
//    
//    // MARK: - Methods
//    private func nextPage() {
//        guard let currentIndex = OnboardingPage.allCases.firstIndex(of: currentPage),
//              currentIndex < OnboardingPage.allCases.count - 1 else { return }
//        currentPage = OnboardingPage.allCases[currentIndex + 1]
//    }
//    
//    private func previousPage() {
//        guard let currentIndex = OnboardingPage.allCases.firstIndex(of: currentPage),
//              currentIndex > 0 else { return }
//        currentPage = OnboardingPage.allCases[currentIndex - 1]
//    }
//    
//    private func handleSkip() {
//        // Handle skip action - complete onboarding or navigate away
//        dismiss()
//    }
//    
//    private func handleComplete() {
//        // Handle completion - navigate to next screen or complete onboarding
//        dismiss()
//    }
//}
//
//#Preview {
//    NavigationStack {
//        InitialFlowScreenView()
//    }
//}
