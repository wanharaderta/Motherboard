//
//  UserRoleScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 12/12/25.
//

import SwiftUI

struct OnboardingUserRoleScreenView: View {
    
    @State private var selectedRole: UserRoleModel?
    
    var onContinue: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xxl) {
                        headerView
                        contentView
                        continueButton
                    }
                    .padding(Spacing.xl)
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text(Constants.howWouldYouLikeToUseMotherboard)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundColor(Color.codGreyText)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(Constants.selectARole)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Role Selection Cards
    private var contentView: some View {
        VStack(spacing: Spacing.l) {
            ForEach(UserRoleModel.allCases, id: \.self) { role in
                itemCardView(for: role)
            }
        }
    }
}

// MARK: - item card view
extension OnboardingUserRoleScreenView {
    private func itemCardView(for role: UserRoleModel) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedRole = role
            }
        }) {
            HStack(spacing: Spacing.m) {
                Image(role.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 83, height: 83)
                    .foregroundColor(Color.summerGreen)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        
                        Text(role.title)
                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title20)
                            .foregroundColor(Color.primaryGreen900)
                        
                        Spacer()
                        
                        
                        ZStack {
                            Circle()
                                .stroke(
                                    selectedRole == role ? Color.primaryGreen900 : Color.green500,
                                    lineWidth: 2
                                )
                                .frame(width: 14, height: 14)
                            
                            if selectedRole == role {
                                Circle()
                                    .fill(Color.primaryGreen900)
                                    .frame(width: 14, height: 14)
                            }
                        }
                    }
                    
                    Text(role.description)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                        .foregroundColor(Color.mineShaft.opacity(0.57))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.vertical, Spacing.xs)
            .padding(.horizontal, Spacing.s)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedRole == role ? Color.primaryGreen900 : Color.green500,
                        lineWidth: 1.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                if selectedRole != nil {
                    handleContinue()
                }
            }) {
                Text(Constants.continueString)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(selectedRole != nil ? Color.white : Color.green500)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(selectedRole != nil ? Color.primaryGreen900 : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                selectedRole != nil ? Color.white : Color.green500,
                                lineWidth: 1
                            )
                    )
            }
            .disabled(selectedRole == nil)
        }
        .background(Color.white)
        .padding(.top, Spacing.xl)
    }
}

// MARK: - Helpers
extension OnboardingUserRoleScreenView {
    // MARK: - Actions
    private func handleContinue() {
        guard let role = selectedRole else { return }
        // Handle navigation or role selection
        print("Selected role: \(role.rawValue)")
        onContinue?()
    }
}

#Preview {
    NavigationStack {
        OnboardingUserRoleScreenView()
    }
}
