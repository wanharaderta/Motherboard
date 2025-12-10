//
//  OnboardingPageView.swift
//  Motherboard
//
//  Created by Wanhar on 10/12/25.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPageModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(.horizontal, Spacing.xl)
            
            VStack(spacing: Spacing.m) {
                Text(page.title)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                    .foregroundColor(Color.codGreyText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                
                Text(page.subtitle)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                    .foregroundColor(Color.mineShaftText.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            .padding(.top, Spacing.xxl)
            .padding(.bottom, Spacing.xxxl)
        }
    }
}

#Preview {
    OnBoardingScreenView()
}
