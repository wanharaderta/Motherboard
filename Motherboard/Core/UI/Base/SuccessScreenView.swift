//
//  SuccessScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 29/12/25.
//

import SwiftUI

struct SuccessScreenView: View {
    @Environment(Router.self) private var router
    
    // MARK: - Properties
    var title: String = "Routine Created!"
    var description: String = "Your child's meals & bottle routine is now active."
    var showPrimaryButton: Bool = true
    var showSecondaryButton: Bool = true
    var primaryButtonTitle: String = "Create another routine"
    var secondaryButtonTitle: String = "Home Page"
    var primaryButtonAction: (() -> Void)? = nil
    var secondaryButtonAction: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            
            Spacer()
            
            headerView
            
            Spacer()
                .frame(height: Spacing.xxxl)
            
            contentView
            
            Spacer()
            
            if showPrimaryButton || showSecondaryButton {
                footerView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
    }
    
    private var headerView: some View {
        Image("icConfetti")
            .resizable()
            .frame(width: 227, height: 227)
    }
    
    private var contentView: some View {
        VStack(spacing: Spacing.s) {
            Text(title)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title20)
                .foregroundColor(Color.black400)
            
            Text(description)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                .foregroundColor(Color.black300)
        }
    }
    
    private var footerView: some View {
        VStack(spacing: Spacing.m) {
            if showPrimaryButton {
                primaryButton
            }
            if showSecondaryButton {
                secondaryButton
            }
        }
        .padding(.bottom, Spacing.xxxl)
    }
}

extension SuccessScreenView {
    private var primaryButton: some View {
        Button(action: {
            if let action = primaryButtonAction {
                action()
            } else {
                router.pop()
            }
        }) {
            Text(primaryButtonTitle)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.primaryGreen900)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, Spacing.xl)
    }
    
    private var secondaryButton: some View {
        Button(action: {
            if let action = secondaryButtonAction {
                action()
            } else {
                router.popToRoot()
            }
        }) {
            Text(secondaryButtonTitle)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                .foregroundColor(Color.green500)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green500, lineWidth: 1)
                )
        }
        .padding(.horizontal, Spacing.xl)
    }
}

#Preview {
    SuccessScreenView()
}
