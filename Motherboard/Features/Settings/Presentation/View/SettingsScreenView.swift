//
//  SettingsScreenView.swift
//  Motherboard
//
//  Created by Wanhar on 02/01/26.
//

import SwiftUI

struct SettingsScreenView: View {
    @State private var router = Router()
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            VStack(spacing: 0) {
                headerView
                searchBarView
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.groupedSettingsItems.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { section in
                            VStack(alignment: .leading, spacing: 0) {
                                sectionHeader(section)
                                
                                VStack(spacing: Spacing.s) {
                                    ForEach(viewModel.groupedSettingsItems[section] ?? []) { item in
                                        SettingsItemCellView(
                                            item: item,
                                            toggleBinding: item.type == .toggle ? Binding(
                                                get: { viewModel.getToggleValue(for: item.id) },
                                                set: { viewModel.setToggleValue(for: item.id, value: $0) }
                                            ) : nil,
                                            onNavigationTap: {
                                                handleNavigation(for: item)
                                            }
                                        )
                                        .padding(.horizontal, Spacing.l)
                                    }
                                }
                                .padding(.top, Spacing.s)
                            }
                            .padding(.bottom, Spacing.l)
                        }
                        
                        // Logout Button
                        logoutButton
                    }
                }
                .scrollIndicators(.hidden)
                .background(Color.white)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.vertical)
            .navigationDestination(for: ProfileRoute.self) { route in
                ProfileDestinationsView(route: route)
                    .environment(router)
            }
        }
    }
}

// MARK: - Extension
extension SettingsScreenView {
    // MARK: - Header View
    private var headerView: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            
            Text(Constants.settings)
                .appFont(name: .montserrat, weight: .semibold, size: FontSize.title28)
                .foregroundStyle(Color.green50)
        }
        .frame(maxWidth: .infinity, maxHeight: 106)
        .background(Color.primaryGreen900)
    }
    
    // MARK: - Search Bar View
    private var searchBarView: some View {
        HStack(spacing: Spacing.s) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.mineShaft.opacity(0.6))
                .font(.system(size: 16, weight: .medium))
            
            TextField(Constants.searchForASetting, text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaft)
        }
        .padding(Spacing.m)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, Spacing.l)
        .padding(.top, Spacing.m)
    }
    
    // MARK: - Section Header
    private func sectionHeader(_ section: SettingsSection) -> some View {
        HStack {
            Text(section.rawValue)
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                .foregroundColor(Color.mineShaft.opacity(0.6))
                .textCase(.none)
            Spacer()
        }
        .padding(.horizontal, Spacing.l)
        .padding(.top, Spacing.l)
    }
    
    // MARK: - Handle Navigation
    private func handleNavigation(for item: SettingsItemModel) {
        switch item.id {
        case "account_settings":
            router.push(to: ProfileRoute.accountDetails)
        default:
            break
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            // Handle logout
        }) {
            HStack {
                Image("icLogout")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text(Constants.logout)
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                    .foregroundColor(Color.red)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.red)
            }
            .padding(.vertical, Spacing.m)
            .padding(.horizontal, Spacing.l)
            .background(Color.red.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.m)
    }
}

#Preview {
    SettingsScreenView()
}
