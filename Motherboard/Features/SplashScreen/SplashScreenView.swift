//
//  SplashScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 25/11/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Image("icSplashScreen")
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreenView()
}
