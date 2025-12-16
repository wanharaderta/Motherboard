//
//  RegisterScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 10/12/25.
//

import SwiftUI

struct RegisterScreenView: View {
    
    @State private var viewModel = RegisterViewModel()
    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName, email, password, confirmPassword
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    headerView
                    formView
                    socialView
                    loginPrompt
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.xxxl)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
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
                // Navigate to home screen after successful registration
                navigationCoordinator.navigate(to: AppRoute.home)
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text(Constants.registerTitle)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundColor(Color.codGreyText)
            
            Text(Constants.registerSubtitle)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
        }
    }
    
    // MARK: - Form
    private var formView: some View {
        VStack(spacing: Spacing.l) {
            LabeledInputField(
                label: "\(Constants.fullName):",
                placeholder: Constants.enterFullname,
                text: $viewModel.fullName,
                autocapitalization: .words,
                field: .fullName,
                focus: $focusedField
            )
            
            LabeledInputField(
                label: "\(Constants.emailAddress):",
                placeholder: Constants.enterEmail,
                text: $viewModel.email,
                keyboardType: .emailAddress,
                autocapitalization: .never,
                field: .email,
                focus: $focusedField
            )
            
            LabeledInputField(
                label: "\(Constants.password):",
                placeholder: Constants.enterPassword,
                text: $viewModel.password,
                isSecure: true,
                field: .password,
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
                    await viewModel.signUpWithEmail()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.summerGreen))
                    } else {
                        Text(Constants.createAccount)
                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                            .foregroundStyle(Color.green500)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green500, lineWidth: 1)
                )
            }
            .disabled(viewModel.isLoading)
            .padding(.top, Spacing.xl28)
        }
        .padding(.top, Spacing.l)
    }
    
    // MARK: - Social Section
    private var socialView: some View {
        VStack(spacing: Spacing.m) {
            HStack(spacing: Spacing.s) {
                Rectangle()
                    .fill(Color.tundora.opacity(0.2))
                    .frame(height: 1)
                
                Text(Constants.orSignUpWith)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.mineShaftOpacity86)
                
                Rectangle()
                    .fill(Color.tundora.opacity(0.2))
                    .frame(height: 1)
            }
            
            HStack(spacing: Spacing.l) {
                socialButton(image: "icGoogle") {
                    Task { await viewModel.signUpWithGoogle() }
                }
                socialButton(image: "icApple") {
                    
                }
            }
        }
        .padding(.top, Spacing.xs)
    }
    
    private func socialButton(image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: Spacing.s) {
                Image(image)
                    .frame(width: 24, height: 24)
            }
            .frame(width: 48, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
            )
        }
        .padding(.top, Spacing.xxs)
    }
    
    // MARK: - Login Prompt
    private var loginPrompt: some View {
        HStack(spacing: Spacing.xxs) {
            Spacer()
            Text(Constants.alreadyHaveAnAccount)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                .foregroundColor(Color.mineShaftOpacity86)
            
            Button(action: {
              //
            }) {
                Text(Constants.logIn)
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                    .foregroundColor(Color.primaryGreen900)
            }
            Spacer()
        }
        .padding(.bottom, Spacing.xl)
    }
}

#Preview {
    RegisterScreenView()
}
