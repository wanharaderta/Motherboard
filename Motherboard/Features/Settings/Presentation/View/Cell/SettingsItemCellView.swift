//
//  SettingsItemCellView.swift
//  Motherboard
//
//  Created by Cursor on 02/01/26.
//

import SwiftUI

struct SettingsItemCellView: View {
    let item: SettingsItemModel
    var toggleBinding: Binding<Bool>?
    var onNavigationTap: (() -> Void)?
    
    var body: some View {
        switch item.type {
        case .navigation:
            Button(action: {
                onNavigationTap?()
            }) {
                cellContent
            }
            
        case .toggle:
            if let toggleBinding = toggleBinding {
                cellContentWithToggle(binding: toggleBinding)
            } else {
                cellContentWithToggle(binding: .constant(false))
            }
        }
    }
    
    // MARK: - Cell Content
    private var cellContent: some View {
        HStack(spacing: Spacing.s) {
            if !item.icon.isEmpty {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            
            Text(item.title)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                .foregroundColor(Color.black300)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.mineShaft)
        }
        .padding(.horizontal, Spacing.m)
        .padding(.vertical, Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - Cell Content With Toggle
    private func cellContentWithToggle(binding: Binding<Bool>) -> some View {
        HStack(spacing: Spacing.s) {
            if !item.icon.isEmpty {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            
            Text(item.title)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                .foregroundColor(Color.black300)
            
            Spacer()
            
            Toggle("", isOn: binding)
                .toggleStyle(SwitchToggleStyle(tint: Color.primaryGreen900))
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.m)
        .background(Color.green50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    let item = SettingsItemModel(
        id: "account_settings",
        section: .accountAndAccess,
        title: Constants.accountSettings,
        icon: "icAccountSettings",
        type: .navigation
    )
    
    SettingsItemCellView(
        item: item,
        onNavigationTap: {
            // Handle navigation
        }
    )
}

