//
//  ItemRoutinesCellView.swift
//  Motherboard
//
//  Created by Wanhar on 15/12/25.
//

import Foundation
import SwiftUI

struct ItemRoutinesCellView: View {
    
    // MARK: - Properties
    
    let routine: RoutineType
    @Binding var selectedRoutines: Set<RoutineType>
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if selectedRoutines.contains(routine) {
                    selectedRoutines.remove(routine)
                } else {
                    selectedRoutines.insert(routine)
                }
            }
        }) {
            HStack(spacing: Spacing.m) {
                // Icon Container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(routine.iconBackgroundColor)
                        .frame(width: 44, height: 44)
                    
                    Image(routine.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(routine.title)
                        .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                    
                    Text(routine.description)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                        .foregroundColor(Color.grey500)
                }
                
                Spacer()
                
                // Radio Button
                ZStack {
                    Circle()
                        .stroke(
                            selectedRoutines.contains(routine) ? Color.green500 : Color.grey500,
                            lineWidth: 2
                        )
                        .frame(width: 20, height: 20)
                    
                    if selectedRoutines.contains(routine) {
                        Circle()
                            .fill(Color.green500)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(Spacing.m)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedRoutines.contains(routine) ? Color.green500 : Color.borderNeutralWhite,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
