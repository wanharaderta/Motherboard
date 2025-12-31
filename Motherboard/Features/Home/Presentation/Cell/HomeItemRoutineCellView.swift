//
//  HomeItemRoutineCellView.swift
//  Motherboard
//
//  Created by Wanhar on 22/12/25.
//

import SwiftUI

struct HomeItemRoutineCellView: View {
    
    var body: some View {
        HStack {
            Image("icBabyBottle")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.leading, Spacing.m)
            
            Text("Meals & Bottles")
                .appFont(name: .montserrat, weight: .medium, size: FontSize.title12)
                .foregroundColor(Color.black300)
                .padding(.trailing, Spacing.m)
        }
        .frame(maxHeight: 34)
        .background(Color.bgYellow100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    HomeItemRoutineCellView()
}
