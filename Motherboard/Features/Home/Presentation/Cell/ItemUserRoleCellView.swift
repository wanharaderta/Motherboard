//
//  ItemUserRoleCellView.swift
//  Motherboard
//
//  Created by Wanhar on 16/12/25.
//

import SwiftUI

struct ItemUserRoleCellView: View {
    let role: UserRoleModel
    let selectedRole: UserRoleModel?
    let onSelect: (UserRoleModel) -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                onSelect(role)
            }
        }) {
            HStack(spacing: Spacing.m) {
                Image(role.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 83, height: 83)
                    .foregroundColor(Color.summerGreen)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(role.title)
                            .appFont(name: .montserrat, weight: .semibold, size: FontSize.title20)
                            .foregroundColor(Color.primaryGreen900)
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .stroke(
                                    selectedRole == role ? Color.primaryGreen900 : Color.green500,
                                    lineWidth: 2
                                )
                                .frame(width: 14, height: 14)
                            
                            if selectedRole == role {
                                Circle()
                                    .fill(Color.primaryGreen900)
                                    .frame(width: 14, height: 14)
                            }
                        }
                    }
                    
                    Text(role.description)
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                        .foregroundColor(Color.mineShaft.opacity(0.57))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.vertical, Spacing.xs)
            .padding(.horizontal, Spacing.s)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedRole == role ? Color.primaryGreen900 : Color.green500,
                        lineWidth: 1.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ItemUserRoleCellView(
        role: .parent,
        selectedRole: .parent,
        onSelect: { _ in }
    )
}
