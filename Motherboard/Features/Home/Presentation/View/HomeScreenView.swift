//
//  HomeScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 25/11/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    // MARK: - Properties
    @StateObject private var authManager = AuthManager.shared
    @State private var viewModel = HomeViewModel()
    @State private var initialViewModel = InitialViewModel()
    
    @State private var fetchTask: Task<Void, Never>?
    @State private var showAddChild = false
    
    var body: some View {
        ZStack {
//            VStack(spacing: 0) {
//                headerView
//                contentView
//            }
//            
//            // Show Initial flow if user hasn't filled onboarding data
//            if let userData = authManager.userData, !userData.isFillOnboardingData {
//                InitialUserRoleScreenView()
//            }
            InitialUserRoleScreenView()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.summerGreen)
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
        .sheet(isPresented: $showAddChild) {
            NavigationStack {
                AddChildScreenView()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.bgBridalHeath)
            
            Text(Constants.appName)
                .appFont(name: .spProDisplay, weight: .semibold, size: FontSize.largeTitle30)
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Spacing.xxl)
    }
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            Text(viewModel.greeting)
                .appFont(name: .spProDisplay, weight: .reguler, size: FontSize.title28)
                .foregroundColor(Color.tundora)
                .padding(.top, Spacing.xxl)
            
            scheduleView
            kidsView
            upcomingView
            
            Spacer()
            
            shareButton
        }
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .background(Color.bgBridalHeath)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .edgesIgnoringSafeArea(.bottom)
        .padding(.top, Spacing.xxl)
    }
}

// MARK: - Section Views
extension HomeScreenView {
    
    // MARK: - Schedule View
    private var scheduleView: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(Constants.todaysSchedule)
                .appFont(name: .spProDisplay, weight: .reguler, size: FontSize.title25)
                .foregroundColor(Color.tundora)
            
            if let schedule = viewModel.todaySchedule {
                HomeKidsCellView(
                    name: schedule.kidName,
                    age: schedule.kidAge,
                    cellType: .schedule(time: schedule.time),
                    photoUrl: schedule.photoUrl
                )
            }
        }
    }
    
    // MARK: - Kids View
    private var kidsView: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text(Constants.kids)
                    .appFont(name: .spProDisplay, weight: .reguler, size: FontSize.title25)
                    .foregroundColor(Color.tundora)
                
                Spacer()
                
                Button(action: {
                    showAddChild = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.summerGreen)
                }
            }
            
            ForEach(viewModel.kids) { kid in
                HomeKidsCellView(
                    name: kid.name,
                    age: kid.age,
                    cellType: .kidRow,
                    photoUrl: kid.photoUrl
                )
            }
        }
    }
    
    // MARK: - Upcoming View
    private var upcomingView: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(Constants.upcoming)
                .appFont(name: .spProDisplay, weight: .reguler, size: FontSize.title25)
                .foregroundColor(Color.tundora)
            
            ForEach(viewModel.upcomingItems) { item in
                HStack {
                    Text(item.title)
                        .font(.system(size: 16))
                        .foregroundColor(Color.tundora)
                    
                    Spacer()
                    
                    Text(item.value)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.tundora)
                }
            }
            .customCardView(cornerRadius: 12)
        }
    }
    
    // MARK: - Share Button
    private var shareButton: some View {
        Button(action: {
            viewModel.shareSitterSheet()
        }) {
            HStack(spacing: Spacing.m) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color.summerGreen)
                    .font(.system(size: 18, weight: .medium))
                
                Text(Constants.shareSitterSheet)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.tundora)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.starkWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom, Spacing.xl)
    }
}

#Preview {
    HomeScreenView()
}
