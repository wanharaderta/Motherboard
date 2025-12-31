////
////  EmailVerificationScreenView.swift
////  Motherboard
////
////  Created by Wanhar on 19/12/25.
////
//
//import SwiftUI
//
//struct EmailVerificationScreenView: View {
//    
//    @State private var viewModel = AuthViewModel()
//    @Environment(Router.self) private var navigationCoordinator
//    @FocusState private var focusedField: OTPField?
//    @State private var otpCode: [String] = Array(repeating: "", count: 5)
//    
//    enum OTPField: Hashable {
//        case field0, field1, field2, field3, field4
//    }
//    
//    // MARK: - Validation
//    private var isFormValid: Bool {
//        otpCode.allSatisfy { !$0.isEmpty }
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.white.ignoresSafeArea()
//            
//            botttomBackground
//            
//            ScrollView {
//                VStack(alignment: .leading, spacing: Spacing.l) {
//                    headerView
//                    titleView
//                    formView
//                    resendCodeView
//                }
//                .padding(.horizontal, Spacing.xl)
//                .padding(.vertical, Spacing.xxxl)
//            }
//            .scrollDismissesKeyboard(.interactively)
//        }
//        .navigationBarBackButtonHidden(true)
//        .background(Color.white)
//        .edgesIgnoringSafeArea([.horizontal, .bottom])
//    }
//    
//    // MARK: - Bottom Background
//    private var botttomBackground: some View {
//        VStack {
//            Spacer()
//            
//            Image("bgBottomScreen")
//                .resizable()
//                .scaledToFill()
//                .frame(maxWidth: .infinity)
//                .frame(height: 124)
//                .ignoresSafeArea(edges: [.horizontal, .bottom])
//                .clipped()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//    
//    // MARK: - Header View
//    private var headerView: some View {
//        HStack(spacing: Spacing.m) {
//            Button(action: {
//                withAnimation {
//                    navigationCoordinator.pop()
//                }
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(Color.mineShaft)
//                    .font(.system(size: 20, weight: .medium))
//            }
//            
//            Text(Constants.emailVerification)
//                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title16)
//                .foregroundColor(Color.mineShaft)
//            
//            Spacer()
//        }
//        .frame(height: 44)
//    }
//    
//    // MARK: - Title View
//    private var titleView: some View {
//        VStack(alignment: .leading, spacing: Spacing.s) {
//            Text(Constants.checkYourInbox)
//                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
//                .foregroundColor(Color.codGreyText)
//            
//            Text(Constants.passwordResetLinkSent)
//                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
//                .foregroundColor(Color.mineShaftOpacity86)
//        }
//        .padding(.top, Spacing.l)
//    }
//    
//    // MARK: - Form View
//    private var formView: some View {
//        VStack(spacing: Spacing.l) {
//            // OTP Code Input Fields
//            HStack(spacing: Spacing.m) {
//                ForEach(0..<5, id: \.self) { index in
//                    OTPTextField(
//                        text: $otpCode[index],
//                        field: OTPField.allCases[index],
//                        focus: $focusedField
//                    )
//                }
//            }
//            .padding(.top, Spacing.l)
//            
//            // Continue Button
//            Button(action: {
//                // TODO: Handle verification
//                let code = otpCode.joined()
//                print("Verification code: \(code)")
//            }) {
//                HStack {
//                    if viewModel.isLoading {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
//                    } else {
//                        Text(Constants.continueString)
//                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
//                            .foregroundStyle(isFormValid ? Color.white : Color.green500)
//                    }
//                }
//                .foregroundColor(isFormValid ? Color.white : Color.green500)
//                .frame(maxWidth: .infinity)
//                .frame(height: 50)
//                .background(isFormValid ? Color.primaryGreen900 : Color.white)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(
//                            isFormValid ? Color.white : Color.green500,
//                            lineWidth: 1
//                        )
//                )
//            }
//            .disabled(!isFormValid || viewModel.isLoading)
//            .padding(.top, Spacing.xl28)
//        }
//        .padding(.top, Spacing.l)
//    }
//    
//    // MARK: - Resend Code View
//    private var resendCodeView: some View {
//        HStack(spacing: Spacing.xxs) {
//            Spacer()
//            Text(Constants.didntReceiveEmail)
//                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
//                .foregroundColor(Color.mineShaftOpacity86)
//            
//            Button(action: {
//                Task {
//                    await viewModel.resetPassword()
//                }
//            }) {
//                Text(Constants.resendCode)
//                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
//                    .foregroundColor(Color.primaryGreen900)
//            }
//            Spacer()
//        }
//        .padding(.top, Spacing.l)
//    }
//}
//
//// MARK: - OTP Text Field Component
//struct OTPTextField: View {
//    @Binding var text: String
//    let field: EmailVerificationScreenView.OTPField
//    var focus: FocusState<EmailVerificationScreenView.OTPField?>.Binding
//    
//    var body: some View {
//        TextField("", text: $text)
//            .textFieldStyle(.plain)
//            .keyboardType(.numberPad)
//            .multilineTextAlignment(.center)
//            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title20)
//            .foregroundColor(Color.codGreyText)
//            .frame(width: 56, height: 56)
//            .background(Color.white)
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(isFocused ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
//            )
//            .focused(focus, equals: field)
//            .onChange(of: text) { oldValue, newValue in
//                // Only allow numbers
//                let filtered = newValue.filter { $0.isNumber }
//                if filtered != newValue {
//                    text = filtered
//                    return
//                }
//                
//                // Limit to single character
//                if newValue.count > 1 {
//                    text = String(newValue.prefix(1))
//                }
//                
//                // Move to next field if character entered
//                if !text.isEmpty && oldValue.isEmpty {
//                    moveToNextField()
//                }
//                // Move to previous field if deleted
//                else if text.isEmpty && !oldValue.isEmpty {
//                    moveToPreviousField()
//                }
//            }
//    }
//    
//    private var isFocused: Bool {
//        focus.wrappedValue == field
//    }
//    
//    private func moveToNextField() {
//        switch field {
//        case .field0:
//            focus.wrappedValue = .field1
//        case .field1:
//            focus.wrappedValue = .field2
//        case .field2:
//            focus.wrappedValue = .field3
//        case .field3:
//            focus.wrappedValue = .field4
//        case .field4:
//            focus.wrappedValue = nil
//        }
//    }
//    
//    private func moveToPreviousField() {
//        switch field {
//        case .field1:
//            focus.wrappedValue = .field0
//        case .field2:
//            focus.wrappedValue = .field1
//        case .field3:
//            focus.wrappedValue = .field2
//        case .field4:
//            focus.wrappedValue = .field3
//        case .field0:
//            focus.wrappedValue = nil
//        }
//    }
//}
//
//extension EmailVerificationScreenView.OTPField: CaseIterable {
//    static var allCases: [EmailVerificationScreenView.OTPField] {
//        [.field0, .field1, .field2, .field3, .field4]
//    }
//}
//
//#Preview {
//    EmailVerificationScreenView()
//}
