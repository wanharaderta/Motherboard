//
//  ItemDailyRoutineCellView.swift
//  Motherboard
//
//  Created by Wanhar on 23/12/25.
//

import SwiftUI

struct ItemDailyRoutineCellView: View {
    
    let routine: RoutineType
    var onTap: ((RoutineType) -> Void)
    
    var body: some View {
        Button(action: { onTap(routine) }) {
            HStack(spacing: Spacing.m) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(routine.iconBackgroundColor)
                        .frame(width: 30, height: 30)
                    
                    Image(routine.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(routine.title)
                        .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                        .foregroundStyle(Color.mineShaft.opacity(0.9))
                    
                    Text(routine.description)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title10)
                        .foregroundStyle(Color.mineShaft.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.primaryGreen900)
            }
            .customCardView(color: Color.green50, cornerRadius: 8)
            .frame(maxWidth: .infinity, minHeight: 47)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ItemDailyRoutineCellView(routine: .bottlesAndMeals, onTap: {_ in 
        
    })
}
