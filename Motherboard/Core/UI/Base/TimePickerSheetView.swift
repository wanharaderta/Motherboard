//
//  TimePickerSheetView.swift
//  Motherboard
//
//  Created by Wanhar on 26/12/25.
//

import SwiftUI

struct TimePickerSheetView: View {
    @Binding var selectedDate: Date
    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Select Time")
                    .appFont(name: .montserrat, weight: .bold, size: FontSize.title16)
                    .foregroundColor(Color.black400)
                
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.m)
            
            Divider()
            
            // Time Picker
            DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
            
            Divider()
            
            // Footer Button
            Button(action: {
                onDone()
            }) {
                Text(Constants.done)
                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.primaryGreen900)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.m)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
