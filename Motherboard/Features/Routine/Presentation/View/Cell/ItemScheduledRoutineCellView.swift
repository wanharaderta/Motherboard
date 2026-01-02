//
//  ItemScheduledRoutineCellView.swift
//  Motherboard
//
//  Created by Wanhar on 23/12/25.
//

import SwiftUI

struct ItemScheduledRoutineCellView: View {
    
    let routine: RoutinesModelResponse
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    
    var body: some View {
        HStack(spacing: Spacing.m) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.bgWhisper)
                    .frame(width: 30, height: 30)
                
                Image("icNapping")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(routine.timeRangeDisplay)
                    .appFont(name: .montserrat, weight: .medium, size: FontSize.title14)
                    .foregroundStyle(Color.mineShaft.opacity(0.9))
                
                Text(routine.title)
                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title10)
                    .foregroundStyle(Color.mineShaft.opacity(0.6))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            HStack(spacing: Spacing.m) {
                Button(action: { onEdit?() }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.black100)
                }
                .buttonStyle(.plain)
                
                Button(action: { onDelete?() }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.black100)
                }
                .buttonStyle(.plain)
            }
        }
        .customCardView(color: Color.green50, cornerRadius: 8)
        .frame(maxWidth: .infinity, minHeight: 53)
    }
}

#Preview {
    ItemScheduledRoutineCellView(
        routine: RoutinesModelResponse(
            id: "",
            code: "",
            title: "Sonia's having a short nap",
            description: "",
            kidID: "",
            scheduledTime: "07:00AM",
            endScheduledTime: "09:00AM"
        )
    )
}
