//
//  MainHealthMedicalInfoScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 13/12/25.
//

import SwiftUI

struct MainHealthMedicalInfoScreenView: View {
    
    // MARK: - Properties
    @Environment(InitialViewModel.self) private var initialViewModel
    @Environment(Router.self) private var navigationCoordinator
    @State private var selectedTab: Int = 0
    
    private let totalScreens: Int = 6
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: Spacing.m) {
                    headerView
                    if !isRoutinesView {
                        progressBarView
                    }
                }
                .padding(.horizontal, Spacing.xl)
                
                contentView
            }
            .navigationBarBackButtonHidden()
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.white.ignoresSafeArea())
            .disabled(initialViewModel.isLoading)
            
            // Loading Overlay - Blocks all interactions
            if initialViewModel.isLoading {
                loadingOverlay
            }
        }
        .alert(Constants.error, isPresented: Binding(get: { initialViewModel.isError }, set: { if !$0 { initialViewModel.clearError() } })) {
            Button(Constants.ok) {
                initialViewModel.clearError()
            }
        } message: {
            Text(initialViewModel.errorMessage ?? Constants.errorOccurred)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Button(action: {
                    handleBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.mineShaft)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Spacer()
                
                Button(action: {
                    nextTab()
                }) {
                    Text(Constants.skipForNow)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .foregroundColor(Color.primaryGreen900)
                        .underline()
                }
            }
            .frame(height: 44)
            
            Text(headerTitle)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundColor(Color.codGreyText)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Text(headerSubtitle)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentView: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<totalScreens, id: \.self) { index in
                            viewForIndex(index)
                                .frame(width: geometry.size.width)
                                .id(index)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollDisabled(true) // Disable user scrolling - only allow programmatic navigation
                .onChange(of: selectedTab) { oldValue, newValue in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newValue, anchor: .leading)
                    }
                }
                .onAppear {
                    // Scroll to initial position
                    proxy.scrollTo(selectedTab, anchor: .leading)
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewForIndex(_ index: Int) -> some View {
        switch index {
        case 0:
            InitialAllergiesView(
                onContinue: { nextTab() },
                onSkip: { onSkip?() }
            )
        case 1:
            InitialMedicalConditionView(
                onContinue: { nextTab() },
                onSkip: { onSkip?() }
            )
        case 2:
            InitialMedicationsView(
                onContinue: { nextTab() },
                onSkip: { onSkip?() }
            )
        case 3:
            InitialEmergencyMedicationView(
                onContinue: { nextTab() },
                onSkip: { onSkip?() }
            )
        case 4:
            InitialInformationView(
                onContinue: { nextTab() },
                onSkip: { onSkip?() }
            )
        case 5:
            InitialRoutinesView(
                onContinue: { nextTab() },
                onSkip: { onSkip?() }
            )
        default:
            EmptyView()
        }
    }
}

// MARK: - Helpers
extension MainHealthMedicalInfoScreenView {
    
    private var progressBarView: some View {
        CustomProgressBarView(
            progress: calculateProgress(),
            color: Color.green500,
            height: 2,
            backgroundColor: Color.green200
        )
    }
    
    private func calculateProgress() -> Double {
        // Only calculate progress for first 5 screens (0-4), exclude InitialRoutinesView (5)
        let progressScreens: Int = 5
        let currentScreen = selectedTab + 1 // Convert to 1-indexed
        
        // Cap at 5 screens for progress calculation
        let cappedScreen = min(currentScreen, progressScreens)
        return Double(cappedScreen) / Double(progressScreens)
    }
    
    private func nextTab() {
        guard selectedTab < totalScreens - 1 else {
            onContinue?()
            return
        }
        
        // Direct update - ScrollViewReader will handle animation
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab += 1
        }
    }
    
    /// Handle back behavior:
    /// - If on first tab (InitialAllergiesView), pop navigation stack.
    /// - Otherwise, go to previous tab.
    private func handleBack() {
        if selectedTab > 0 {
            // Direct update - ScrollViewReader will handle animation
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTab -= 1
            }
        } else {
            navigationCoordinator.pop()
        }
    }
    
    private var isRoutinesView: Bool {
        selectedTab == 5
    }
    
    private var headerTitle: String {
        isRoutinesView ? Constants.chooseTheRoutinesYouWantToSetUp : Constants.healthMedicalInfoTitle
    }
    
    private var headerSubtitle: String {
        isRoutinesView ? Constants.youCanSelectOneOrMultipleRoutines : Constants.healthMedicalInfoSubtitle
    }
    
    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            // Full screen background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
                .allowsHitTesting(true)
            
            // Loading indicator centered
            VStack(spacing: Spacing.l) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.primaryGreen900))
                    .scaleEffect(1.5)
                
                Text("Please wait...")
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                    .foregroundColor(Color.codGreyText)
            }
            .padding(Spacing.xl)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
    
}


#Preview {
    NavigationStack {
        MainHealthMedicalInfoScreenView()
    }
}
