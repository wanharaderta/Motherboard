//
//  FontModifiers.swift
//  Motherboard
//
//  Created by Wanhar on 28/11/25.
//

import Foundation
import SwiftUI
import UIKit

enum MotherboardFontName: String {
    case spProDisplay = "SFProDisplay"
    case montserrat = "Montserrat"
}

enum MotherboardFontWeight: String {
    case reguler = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
    case bold = "Bold"
}

extension Font {
    static func appFont(name: MotherboardFontName = .spProDisplay,
                        weight: MotherboardFontWeight = .reguler,
                        size: CGFloat = 14) -> Font {
        var fontName = "\(name.rawValue)-\(weight.rawValue)"
        if weight.rawValue.isEmpty {
            fontName = "\(name.rawValue)"
        }
        if UIFont(name: fontName, size: size) == nil {
            print("Custom font not found: \(fontName). Falling back to system font.")
        }
        
        /// Print font name
        /*
         for family in UIFont.familyNames {
             print("Family: \(family)")
             for name in UIFont.fontNames(forFamilyName: family) {
                 print(" - \(name)")
             }
         }
         */
        
        return .custom(fontName, size: size)
    }
}

struct MotherboardFontModifier: ViewModifier {
    var name: MotherboardFontName = .spProDisplay
    var weight: MotherboardFontWeight = .reguler
    var size: CGFloat = 14
    
    func body(content: Content) -> some View {
        content
            .font(.appFont(name: name, weight: weight, size: size))
    }
}

extension View {
    func appFont(name: MotherboardFontName = .spProDisplay,
                 weight: MotherboardFontWeight = .reguler,
                 size: CGFloat = 14) -> some View {
        modifier(MotherboardFontModifier(name: name, weight: weight, size: size))
    }
}

// MARK: -UIFont Extension
extension UIFont {
    static func appFont(name: MotherboardFontName = .spProDisplay,
                        weight: MotherboardFontWeight = .reguler,
                        size: CGFloat = 14) -> UIFont {
        let fontName = "\(name.rawValue)-\(weight.rawValue)"
        if let font = UIFont(name: fontName, size: size) {
            return font
        } else {
            print("Custom font not found: \(fontName). Falling back to system font.")
            return UIFont.systemFont(ofSize: size)
        }
    }
}
