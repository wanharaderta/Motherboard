//
//  BaseHeaderView.swift
//  Motherboard
//
//  Created by Wanhar on 23/12/25.
//

import SwiftUI

struct BaseHeaderView: View {
    
    var title: String = ""
    var fontSize: CGFloat = FontSize.title22
    var onBack: (() -> Void)?
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            Button(action: { onBack?() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.green50)
            }
            .buttonStyle(.plain)
            
            Text(title)
                .appFont(name: .montserrat, weight: .semibold, size: fontSize)
                .foregroundStyle(Color.green50)
            
            Spacer()
        }
        .padding(.leading, Spacing.xl)
        .padding(.vertical, Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryGreen900)
    }
}

#Preview {
    BaseHeaderView(title: "title", onBack: {
        
    })
}
