//
//  CustomDaysPickerSheetView.swift
//  Motherboard
//
//  Created by Wanhar on 28/12/25.
//

import SwiftUI

struct CustomDaysPickerSheetView: View {
    @Binding var selectedDay: String?
    var onDaySelected: (String) -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(Constants.selectCustomDay)
                    .appFont(name: .montserrat, weight: .bold, size: FontSize.title16)
                    .foregroundColor(Color.black400)
                
                Spacer()
                
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.black300)
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.xxl)
            
            Divider()
            
            // Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Select the day you want this routine to repeat:")
                        .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.m)
                    
                    // All days with single selection
                    HStack(spacing: Spacing.s) {
                        TagCloudView(data: WeekDay.allCases) { day in
                            BorderTagButton(
                                title: day.rawValue,
                                isSelected: selectedDay == day.rawValue,
                                onTap: {
                                    onDaySelected(day.rawValue)
                                },
                                cornerRadius: 8
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    
                    Spacer()
                        .frame(height: Spacing.xl)
                }
            }
            
            Divider()
            
            // Footer
            HStack(spacing: Spacing.m) {
                Button(action: {
                    onDismiss()
                }) {
                    Text("Cancel")
                        .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                        .foregroundColor(Color.black300)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green500, lineWidth: 1)
                        )
                }
                
                Button(action: {
                    onDismiss()
                }) {
                    Text(Constants.done)
                        .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.primaryGreen900)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.m)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
