//
//  CardViewModifier.swift
//  Motherboard
//
//  Created by Wanhar on 27/11/25.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
    var cornerRadius: CGFloat
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content
            .padding(Spacing.m)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func customCardView(color:Color = .white, cornerRadius: CGFloat = 16) -> some View {
        modifier(CardViewModifier(cornerRadius: cornerRadius, color: color))
    }
}
