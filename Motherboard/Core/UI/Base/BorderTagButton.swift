//
//  BorderTagButton.swift
//  Motherboard
//
//  Created by Cursor on 24/12/25.
//

import SwiftUI

struct BorderTagButton: View {
    
    // MARK: - Properties
    let title: String
    var isSelected: Bool = false
    let onTap: () -> Void
    
    // MARK: - Customizable Colors
    var textColor: Color = Color.black200
    var selectedTextColor: Color = Color.primaryGreen900
    var borderColor: Color = Color.black200
    var selectedBorderColor: Color = Color.primaryGreen900
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .foregroundColor(isSelected ? selectedTextColor : textColor)
            }
            .padding(.horizontal, Spacing.xs)
            .frame(height: 29)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isSelected ? selectedBorderColor : borderColor, lineWidth: 0.7)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: Spacing.s) {
        BorderTagButton(
            title: "Breakfast",
            isSelected: true,
            onTap: {}
        )
        
        BorderTagButton(
            title: "Lunch",
            isSelected: false,
            onTap: {}
        )
        
        BorderTagButton(
            title: "Dinner",
            isSelected: false,
            onTap: {}
        )
    }
    .padding()
}
