//
//  UserRoleScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 12/12/25.
//

import SwiftUI

struct InitialUserRoleScreenView: View {
    
    // MARK: - Properties
    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @Environment(InitialViewModel.self) private var viewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: Spacing.xxl) {
                headerView
                contentView
                continueButton
                
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            
            Spacer()
                .frame(height: 44)
            
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
                ItemUserRoleCellView(
                    role: role,
                    selectedRole: viewModel.selectedRole,
                    onSelect: { selectedRole in
                        viewModel.selectedRole = selectedRole
                    }
                )
            }
        }
    }
}

// MARK: - item card view
extension InitialUserRoleScreenView {
    private var continueButton: some View {
        Button(action: {
            guard let role = viewModel.selectedRole else { return }
            navigationCoordinator.navigate(to: InitialRoute.addChild)
        }) {
            Text(Constants.continueString)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                .foregroundColor(viewModel.selectedRole != nil ? Color.white : Color.green500)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(viewModel.selectedRole != nil ? Color.primaryGreen900 : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            viewModel.selectedRole != nil ? Color.white : Color.green500,
                            lineWidth: 1
                        )
                )
        }
        .disabled(viewModel.selectedRole == nil)
        .padding(.vertical, Spacing.xl)
    }
}

#Preview {
    NavigationStack {
        InitialUserRoleScreenView()
    }
}
