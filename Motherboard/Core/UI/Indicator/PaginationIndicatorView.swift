//
//  PaginationIndicatorView.swift
//  Motherboard
//
//  Created by Wanhar on 10/12/25.
//

import SwiftUI

struct PaginationIndicatorView: View {
    
    // MARK: - Properties
    
    let totalPages: Int
    let currentPage: Int
    var activeColor: Color = Color.primaryGreen900
    var inactiveColor: Color = Color.gray.opacity(0.3)
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(0..<totalPages, id: \.self) { index in
                ZStack {
                    if index == currentPage {
                        // Active indicator
                        RoundedRectangle(cornerRadius: 4)
                            .fill(activeColor)
                            .frame(width: 26, height: 6)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.3).combined(with: .opacity),
                                removal: .scale(scale: 0.3).combined(with: .opacity)
                            ))
                    } else {
                        // Inactive indicators
                        Circle()
                            .fill(inactiveColor)
                            .frame(width: 8, height: 8)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.3).combined(with: .opacity),
                                removal: .scale(scale: 0.3).combined(with: .opacity)
                            ))
                    }
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
    }
}

