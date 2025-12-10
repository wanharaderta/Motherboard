//
//  OnBoardingViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 10/12/25.
//

import Foundation

@MainActor
@Observable
final class OnboardingViewModel: BaseViewModel {
    
    let onboardingPages: [OnboardingPageModel] = [
        OnboardingPageModel(
            title: "Set Routines",
            subtitle: "Create daily schedules tailored to your child’s needs.",
            imageName: "icImagePlayingWithDolls"
        ),
        OnboardingPageModel(
            title: "Guide Caregivers",
            subtitle: "Caregivers follow clear instructions and timely reminders.",
            imageName: "icKidsStudyingFromHome"
        ),
        OnboardingPageModel(
            title: "Stay Updated",
            subtitle: "Get instant check-ins and activity updates throughout the day.",
            imageName: "icMobileUser"
        )
    ]
}
