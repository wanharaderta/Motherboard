//
//  CustomInputSheetView.swift
//  Motherboard
//
//  Created by Wanhar on 28/12/25.
//

import SwiftUI

struct CustomInputSheetView: View {
    let title: String
    let instructionText: String
    let placeholder: String
    @Binding var inputText: String
    @FocusState private var isInputFocused: Bool
    var keyboardType: UIKeyboardType = .default
    var onDone: () -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(title)
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
            VStack(alignment: .leading, spacing: Spacing.m) {
                Text(instructionText)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .foregroundColor(Color.black300)
                
                TextField(placeholder, text: $inputText)
                    .textFieldStyle(.plain)
                    .keyboardType(keyboardType)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .padding(Spacing.m)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isInputFocused ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                    )
                    .focused($isInputFocused)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, Spacing.m)
            
            Spacer()
            
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
                    onDone()
                }) {
                    Text(Constants.done)
                        .appFont(name: .montserrat, weight: .semibold, size: FontSize.title14)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(inputText.isEmpty ? Color.gray : Color.primaryGreen900)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(inputText.isEmpty)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.m)
        }
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
        .onAppear {
            isInputFocused = true
        }
    }
}
