//
//  CardViewModifier.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(Spacing.m)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func customCardView(cornerRadius: CGFloat = 16) -> some View {
        modifier(CardViewModifier(cornerRadius: cornerRadius))
    }
}
