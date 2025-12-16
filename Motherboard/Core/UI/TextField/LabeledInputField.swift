//
//  LabeledInputField.swift
//  Motherboard
//
//  Created by Wanhar on 10/12/25.
//

import SwiftUI

/// Reusable labeled text input that matches the auth form style.
struct LabeledInputField<Field: Hashable>: View {
    
    // MARK: - Properties
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .never
    var isSecure: Bool = false
    var labelColor: Color = Color.mineShaftOpacity86
    var textPlaceholderColor: Color = Color.greyText
    var bgPlaceholderColor: Color = Color.white
    var field: Field
    var focus: FocusState<Field?>.Binding
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(Color.mineShaftOpacity86)
            
            inputField
                .padding(Spacing.m)
                .background(bgPlaceholderColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.green200 : Color.borderNeutralWhite, lineWidth: 1)
                )
        }
    }
    
    // MARK: - Private Helpers
    private var inputField: some View {
        Group {
            if isSecure {
                SecureField(
                    "",
                    text: $text,
                    prompt: Text(placeholder).foregroundColor(textPlaceholderColor)
                )
                    .textFieldStyle(.plain)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .focused(focus, equals: field)
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder).foregroundColor(textPlaceholderColor)
                )
                    .textFieldStyle(.plain)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled()
                    .focused(focus, equals: field)
            }
        }
    }
    
    private var isFocused: Bool {
        focus.wrappedValue == field
    }
}


