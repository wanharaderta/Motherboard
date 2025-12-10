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
            bg
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    
    private var bg: Color {
        Color.bgBridalHeath
    }
    
    private var content: some View {
        VStack {
            Spacer()
            
            Image("icSplashScreen")
                .resizable()
                .frame(width: 250, height: 250)
            
            Spacer()
        }
    }
}

#Preview {
    SplashScreenView()
}
