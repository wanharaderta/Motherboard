//
//  View+Extensions.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import SwiftUI

extension View {
    func disableTabViewSwipe() -> some View {
        self.background(TabViewGestureDisabler())
    }
}
