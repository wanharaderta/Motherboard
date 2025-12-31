//
//  ChangePasswordScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 19/12/25.
//

import SwiftUI

struct ChangePasswordScreenView: View {
    
    let oobCode: String
    @State private var viewModel = AuthViewModel()
    @Environment(Router.self) private var navigationCoordinator
    @FocusState private var focusedField: Field?
    
    enum Field {
        case newPassword, confirmPassword
    }
    
    // MARK: - Validation
    private var isFormValid: Bool {
        !viewModel.newPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !viewModel.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        viewModel.newPassword == viewModel.confirmPassword &&
        viewModel.newPassword.count >= 6
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            botttomBackground
            
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    headerView
                    titleView
                    formView
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.xxxl)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .alert(Constants.error, isPresented: Binding(
            get: { viewModel.isError },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Button(Constants.ok) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? Constants.errorOccurred)
        }
        .onChange(of: viewModel.isSuccess) { _, isSuccess in
            if isSuccess {
                // Navigate to success screen
               // navigationCoordinator.navigate(to: AppRoute.success)
            }
        }
    }
    
    // MARK: - Bottom Background
    private var botttomBackground: some View {
        VStack {
            Spacer()
            
            Image("bgBottomScreen")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 124)
                .ignoresSafeArea(edges: [.horizontal, .bottom])
                .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(spacing: Spacing.m) {
            Button(action: {
                withAnimation {
                    navigationCoordinator.pop()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.mineShaft)
                    .font(.system(size: 20, weight: .medium))
            }
            
            Text(Constants.changePassword)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
                .foregroundColor(Color.mineShaft)
            
            Spacer()
        }
        .frame(height: 44)
    }
    
    // MARK: - Title View
    private var titleView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text(Constants.createNewPassword)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundColor(Color.codGreyText)
            
            Text(Constants.enterNewPasswordDescription)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
        }
        .padding(.top, Spacing.l)
    }
    
    // MARK: - Form View
    private var formView: some View {
        VStack(spacing: Spacing.l) {
            LabeledInputField(
                label: "\(Constants.newPassword):",
                placeholder: Constants.enterNewPassword,
                text: $viewModel.newPassword,
                isSecure: true,
                field: .newPassword,
                focus: $focusedField
            )
            
            LabeledInputField(
                label: "\(Constants.confirmPassword):",
                placeholder: Constants.enterConfirmPassword,
                text: $viewModel.confirmPassword,
                isSecure: true,
                field: .confirmPassword,
                focus: $focusedField
            )
            
            Button(action: {
                Task {
                    await viewModel.updatePassword(oobCode: oobCode)
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    } else {
                        Text(Constants.done)
                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                            .foregroundStyle(isFormValid ? Color.white : Color.green500)
                    }
                }
                .foregroundColor(isFormValid ? Color.white : Color.green500)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isFormValid ? Color.primaryGreen900 : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isFormValid ? Color.white : Color.green500,
                            lineWidth: 1
                        )
                )
            }
            .disabled(!isFormValid || viewModel.isLoading)
            .padding(.top, Spacing.xl28)
        }
        .padding(.top, Spacing.l)
    }
}

#Preview {
    ChangePasswordScreenView(oobCode: "test-code")
}
