//
//  LoginScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import SwiftUI

struct LoginScreenView: View {
    
    @State private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        ZStack {
            Color.bgBridalHeath
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                logoSection
                loginForm
                
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
        }
        .navigationBarBackButtonHidden(true)
        .alert(Constants.error, isPresented: $viewModel.isError) {
            Button(Constants.ok) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? Constants.errorOccurred)
        }
    }
    
    // MARK: - Logo Section
    private var logoSection: some View {
        VStack(spacing: Spacing.m) {
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.summerGreen)
            
            Text(Constants.appName)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.tundora)
        }
    }
    
    // MARK: - Login Form
    private var loginForm: some View {
        VStack(spacing: Spacing.xl) {
            // Email Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.email)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.tundora)
                
                TextField(Constants.enterEmail, text: $viewModel.email)
                    .textFieldStyle(.plain)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .padding(Spacing.m)
                    .background(Color.starkWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .email ? Color.summerGreen : Color.clear, lineWidth: 2)
                    )
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(Constants.password)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.tundora)
                
                SecureField(Constants.enterPassword, text: $viewModel.password)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .password)
                    .padding(Spacing.m)
                    .background(Color.starkWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .password ? Color.summerGreen : Color.clear, lineWidth: 2)
                    )
            }
            
            // Login Button
            Button(action: {
                Task {
                    await viewModel.signIn()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(Constants.login)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(viewModel.isLoading ? Color.summerGreen.opacity(0.6) : Color.summerGreen)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.isLoading)
            .padding(.top, Spacing.m)
        }
        .padding(.top, Spacing.xxxl)
    }
}

#Preview {
    NavigationStack {
        LoginScreenView()
    }
}
