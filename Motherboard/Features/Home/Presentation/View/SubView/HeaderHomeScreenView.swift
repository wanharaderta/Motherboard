//
//  HeaderHomeScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 22/12/25.
//

import SwiftUI
import SDWebImageSwiftUI
import Charts

struct HeaderHomeScreenView: View {
    
    // MARK: - Properties
    @Bindable var viewModel: HomeViewModel
    @Binding var selectedBalance: Double?
    @Binding var barSelection: String?
    var router: Router
    
    @State var ppURL: URL?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Spacing.m) {
            Spacer()
                .frame(height: Spacing.xxl)
            
            topHeaderView
            routinesView
        }
        .frame(maxWidth: .infinity, maxHeight: 260)
        .background(Color.primaryGreen900)
        .clipShape(RoundedCorners(radius: 15, corners: [.bottomLeft, .bottomRight]))
    }
    
    // MARK: - Top Header Section
    private var topHeaderView: some View {
        HStack(spacing: Spacing.m) {
            profilePictureView
            userInfoView
            Spacer()
            notificationButton
        }
        .padding(.horizontal, Spacing.xl)
    }
    
    // MARK: - Profile Picture View
    private var profilePictureView: some View {
        Group {
            if let kid = viewModel.selectedKid, !kid.photoUrl.isEmpty {
                WebImage(url: ppURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 51, height: 51)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        )
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .frame(width: 51, height: 51)
                .clipShape(Circle())
                .onAppear {
                    if ppURL == nil {
                        Task {
                            await loadImageURL(gsURL: kid.photoUrl)
                        }
                    }
                }
                .onChange(of: kid.photoUrl) { oldValue, newValue in
                    if newValue != oldValue {
                        Task {
                            await loadImageURL(gsURL: newValue)
                        }
                    }
                }
            } else {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 51, height: 51)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    )
            }
        }
    }
    
    // MARK: - User Info View
    private var userInfoView: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            if let kid = viewModel.selectedKid {
                Text("\(kid.nickname.capitalized), \(kid.dob.ageString())")
                    .appFont(name: .spProDisplay, weight: .medium, size: FontSize.title12)
                    .foregroundColor(Color.wildSandText)
            }
            
            Text(Constants.welcome)
                .appFont(name: .spProDisplay, weight: .semibold, size: FontSize.title20)
                .foregroundColor(Color.wildSandText)
        }
    }
    
    // MARK: - Notification Button
    private var notificationButton: some View {
        Button(action: {
            router.push(to: HomeRoute.notifications)
        }) {
            Image("icHomeNotification")
                .frame(width: 36, height: 36)
        }
    }
    
    // MARK: - Routine Summary Card
    private var routinesView: some View {
        HStack(spacing: Spacing.m) {
            progressChartView
            VStack(spacing: Spacing.xs6) {
                HStack(spacing: Spacing.xxs) {
                    Image("icCalendarRoutines")
                        .scaledToFit()
                        .frame(width: 32, height: 25)
                    
                    Text("\(viewModel.totalRoutines) Routines")
                        .appFont(name: .spProDisplay, weight: .semibold, size: FontSize.title20)
                        .foregroundColor(Color.mineShaft)
                    
                    Spacer()
                }
                
                Text("Caregiver is left with \(viewModel.remainingRoutines) routine for today.")
                    .appFont(name: .spProDisplay, weight: .reguler, size: FontSize.title12)
                    .foregroundColor(Color.black200)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .customCardView(cornerRadius: 12)
        .padding(.horizontal, Spacing.xl)
    }
    
    // MARK: - Progress Chart View
    private var progressChartView: some View {
        let progress = viewModel.routineProgress
        let completed = Int(progress * 100)
        let remaining = 100 - completed
        
        let chartData: [HomeRoutinesModel] = [
            HomeRoutinesModel(name: "Completed", value: completed, color: Color.cyan),
            HomeRoutinesModel(name: "Remaining", value: remaining, color: Color.red)
        ]
        
        return ZStack {
            Chart(chartData) { item in
                SectorMark(
                    angle: .value("Balance", item.value),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(4)
                .foregroundStyle(by: .value("Names", item.name))
                .opacity(barSelection == nil ? 1 : (barSelection! == item.name ? 1 : 0.4))
            }
            .chartAngleSelection(value: $selectedBalance)
            .chartXSelection(value: $barSelection)
            .chartForegroundStyleScale([
                "Completed": Color.cyan,
                "Remaining": Color.red
            ])
            .chartLegend(.hidden)
            .frame(width: 50, height: 50)
            
            VStack(alignment: .center, spacing: 0) {
                Text("\(Int(selectedBalance ?? Double(completed)))%")
                    .appFont(name: .spProDisplay, weight: .reguler, size: FontSize.title10)
                    .foregroundStyle(Color.mineShaft)
            }
        }
        .frame(width: 50, height: 50)
    }
}

// MARK: - Helper Methods
extension HeaderHomeScreenView {
    @MainActor
    private func loadImageURL(gsURL: String) async {
        if let downloadURLString = await gsURL.toFirebaseDownloadURL(),
           let url = URL(string: downloadURLString) {
            ppURL = url
        }
    }
}
