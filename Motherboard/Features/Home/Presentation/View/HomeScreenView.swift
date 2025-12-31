//
//  HomeScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 25/11/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    // MARK: - Properties
    @AppStorage(Enums.hasCompletedInitialData.rawValue) private var hasCompletedInitialData: Bool = false
    @ObservedObject private var authManager = AuthManager.shared
    @State private var viewModel = HomeViewModel()
    @State private var initialViewModel = InitialViewModel()
    
    @State private var fetchTask: Task<Void, Never>?
    @State private var selectedBalance: Double?
    @State private var barSelection: String?
    
    var body: some View {
        ZStack {
            if hasCompletedInitialData {
                VStack(spacing: Spacing.l) {
                    HeaderHomeScreenView(
                        viewModel: viewModel,
                        selectedBalance: $selectedBalance,
                        barSelection: $barSelection
                    )
                    
                    contentView
                    Spacer()
                }
            } else {
                InitialUserRoleScreenView()
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
        .environment(initialViewModel)
        .navigationDestination(for: InitialRoute.self) { route in
            InitialDestinationView(route: route)
                .environment(initialViewModel)
        }
        .onAppear {
            fetchTask = Task {
                viewModel.loadData()
            }
        }
        .onDisappear {
            viewModel.removeListener()
        }
    }
    
    private var contentView: some View {
        VStack {
            Text(Constants.yourRoutines)
                .appFont(name: .spProDisplay, weight: .semibold, size: FontSize.title20)
                .foregroundColor(Color.mineShaft)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Spacing.xl)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    HomeItemRoutineCellView()
                    HomeItemRoutineCellView()
                    HomeItemRoutineCellView()
                }
                .padding(.horizontal, Spacing.xl)
            }
        }
    }
    
}

#Preview {
    HomeScreenView()
}
