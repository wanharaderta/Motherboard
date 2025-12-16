//
//  CustomProgressBarView.swift
//  Motherboard
//
//  Created by Wanhar on 13/12/25.
//

import SwiftUI

struct CustomProgressBarView: View {
    // MARK: - Properties
    let progress: Double // 0.0 to 1.0
    let color: Color
    var height: CGFloat = 6
    var backgroundheight: CGFloat = 0.5
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var cornerRadius: CGFloat = 3
    
    // MARK: - Computed Properties
    private var clampedProgress: Double {
        max(0, min(1, progress))
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: backgroundheight)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .frame(width: geometry.size.width * clampedProgress, height: height)
                    .animation(.easeInOut(duration: 0.3), value: clampedProgress)
            }
        }
        .frame(height: height)
    }
}
