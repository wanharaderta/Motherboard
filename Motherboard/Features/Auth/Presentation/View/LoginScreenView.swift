//
//  LoginScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import SwiftUI

struct LoginScreenView: View {
    
    @Environment(Router.self) private var navigationCoordinator
    
    @FocusState private var focusedField: Field?
    @State private var viewModel = AuthViewModel()
    
    enum Field {
        case email, password
    }
    
    // MARK: - Validation
    private var isFormValid: Bool {
        !viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !viewModel.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            botttomBackground
            
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    headerView
                    formView
                    registerPromptView
                    socialView
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
                navigationCoordinator.replace(with: MainDestionationView.home)
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
    
    // MARK: - Header
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("\(Constants.welcomeBack),")
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundColor(Color.codGreyText)
            
            Text(Constants.accessYourDashboardAndRoutines)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
        }
    }
    
    // MARK: - Form
    private var formView: some View {
        VStack(spacing: Spacing.l) {
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
            
            HStack {
                Spacer()
                Button(action: {
                    navigationCoordinator.push(to: MainDestionationView.forgotPassword)
                }) {
                    Text(Constants.forgotPassword)
                        .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                        .foregroundColor(Color.primaryGreen900)
                }
            }
            
            Button(action: {
                Task {
                    await viewModel.signIn()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    } else {
                        Text(Constants.login)
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
    
    // MARK: - Social Section
    private var socialView: some View {
        VStack(spacing: Spacing.m) {
            HStack(spacing: Spacing.s) {
                Rectangle()
                    .fill(Color.mineShaft.opacity(0.4))
                    .frame(height: 1)
                
                Text(Constants.orContinueWith)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                    .lineLimit(1)
                    .foregroundColor(Color.mineShaftOpacity86)
                
                Rectangle()
                    .fill(Color.mineShaft.opacity(0.4))
                    .frame(height: 1)
            }
            
            HStack(spacing: Spacing.l) {
                socialButton(image: "icGoogle") {
                    //Task { await viewModel.signUpWithGoogle() }
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
    
    // MARK: - Register Prompt View
    private var registerPromptView: some View {
        HStack(spacing: Spacing.xxs) {
            Spacer()
            Text(Constants.dontHaveAnAccountYet)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                .foregroundColor(Color.mineShaftOpacity86)
            
            Button(action: {
                navigationCoordinator.push(to: MainDestionationView.register)
            }) {
                Text(Constants.signUpHere)
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                    .foregroundColor(Color.primaryGreen900)
            }
            Spacer()
        }
        .padding(.bottom, Spacing.xl)
    }
}

#Preview {
    LoginScreenView()
}
