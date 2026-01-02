//
//  AccountDetailsScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

import SwiftUI

struct AccountDetailsScreenView: View {
    
    @Environment(Router.self) private var router
    
    @FocusState private var focusedField: LabelField?
    @State private var name: String = "Marianne Steph"
    @State private var email: String = "MarianneSteph@yahoo.co"
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    accountSettingsSection
                    personalInformationSection
                    securitySection
                }
                .padding(.horizontal, Spacing.l)
                .padding(.top, Spacing.l)
            }
            .background(Color.white)
            
            Spacer()
            
            deactivateAccountButton
        }
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Header
    private var headerView: some View {
        BaseHeaderView(
            title: Constants.accountDetails,
            fontSize: FontSize.title20,
            onBack: {
                router.pop()
            })
    }
    
    // MARK: - Account Settings Section
    private var accountSettingsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Text(Constants.accountSettings)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                .foregroundColor(Color.black400)
            
            Text(Constants.manageAccountDetails)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                .foregroundColor(Color.mineShaft.opacity(0.6))
        }
    }
    
    // MARK: - Personal Information Section
    private var personalInformationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(Constants.personalInformation)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                .foregroundColor(Color.black200)
            
            nameField
            emailField
        }
    }
    
    // MARK: - Name Field
    private var nameField: some View {
        LabeledInputField(
            label: Constants.name,
            placeholder: "",
            text: $name,
            labelColor: Color.black300,
            bgPlaceholderColor: Color.white,
            field: LabelField.fullName,
            focus: $focusedField
        )
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "pencil")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color.mineShaft.opacity(0.4))
                .padding(.trailing, Spacing.m)
                .padding(.bottom, Spacing.l)
        }
    }
    
    // MARK: - Email Field
    private var emailField: some View {
        LabeledInputField(
            label: Constants.email,
            placeholder: "",
            text: Binding(
                get: { email },
                set: { _ in }
            ),
            labelColor: Color.black300,
            bgPlaceholderColor: Color.white,
            field: LabelField.email,
            focus: $focusedField
        )
        .disabled(true)
    }
    
    // MARK: - Security Section
    private var securitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(Constants.security)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                .foregroundColor(Color.black200)
            
            SettingsItemCellView(
                item: SettingsItemModel(
                    id: "change_password",
                    section: .notifications,
                    title: Constants.changePassword,
                    icon: "",
                    type: .navigation
                ),
                onNavigationTap: {
                    // Handle change password navigation
                }
            )
            
            SettingsItemCellView(
                item: SettingsItemModel(
                    id: "enable_face_id",
                    section: .notifications,
                    title: Constants.enableFaceID,
                    icon: "",
                    type: .toggle
                ),
                toggleBinding: Binding(
                    get: { viewModel.enableFaceIDToggle },
                    set: { viewModel.enableFaceIDToggle = $0 }
                )
            )
        }
    }
    
    // MARK: - Deactivate Account Button
    private var deactivateAccountButton: some View {
        Button(action: {
            // Handle deactivate account
        }) {
            Text(Constants.deactivateAccount)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                .foregroundColor(Color.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.m)
                .background(Color.red.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, Spacing.l)
        .padding(.bottom, Spacing.xl)
    }
}

#Preview {
    NavigationStack {
        AccountDetailsScreenView()
    }
}
