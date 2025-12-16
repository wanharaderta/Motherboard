//
//  MenuField.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import SwiftUI

// MARK: - Displayable Protocol

/// Protocol untuk enum yang memiliki displayName property
protocol Displayable {
    var displayName: String { get }
}

// MARK: - MenuField

/// Reusable Menu field component untuk dropdown selection
/// 
/// Example usage:
/// ```swift
/// MenuField(
///     label: "Dose",
///     selectedValue: $viewModel.dose,
///     field: Field.dose,
///     focus: $focusedField
/// )
/// ```
struct MenuField<Option: Hashable & Displayable & CaseIterable, Field: Hashable>: View {
    
    // MARK: - Properties
    
    let label: String
    @Binding var selectedValue: Option
    let field: Field
    var focus: FocusState<Field?>.Binding
    
    // MARK: - Styling Properties
    
    var labelColor: Color = Color.black300
    var textColor: Color = Color.black300
    var backgroundColor: Color = Color.green50
    var focusedBorderColor: Color = Color.green200
    var unfocusedBorderColor: Color = Color.borderNeutralWhite
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            fieldLabel
            
            Menu {
                ForEach(Array(Option.allCases), id: \.self) { option in
                    Button(action: {
                        selectedValue = option
                    }) {
                        HStack {
                            Text(option.displayName)
                            if selectedValue == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                menuLabel
            }
            .onTapGesture {
                focus.wrappedValue = field
            }
        }
    }
    
    // MARK: - Private Views
    
    private var fieldLabel: some View {
        Text(label)
            .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
            .foregroundColor(labelColor)
    }
    
    private var menuLabel: some View {
        HStack {
            Text(selectedValue.displayName)
                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title14)
                .foregroundColor(textColor)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(Color.tundora)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(Spacing.m)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isFocused ? focusedBorderColor : unfocusedBorderColor,
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Computed Properties
    
    private var isFocused: Bool {
        focus.wrappedValue == field
    }
}
