//
//  HomeKidsCellView.swift
//  Motherboard
//
//  Created by Wanhar on 28/11/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

struct HomeKidsCellView: View {
    
    // MARK: - Properties
    let name: String
    let age: String
    let cellType: CellType
    let photoUrl: String?
    @State private var downloadURL: URL?
    
    enum CellType {
        case schedule(time: String)
        case kidRow
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: Spacing.m) {
            // Profile Picture
            if let photoUrl = photoUrl, !photoUrl.isEmpty {
                Group {
                    if let url = downloadURL {
                        WebImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Color.summerGreen.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.summerGreen))
                                )
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.summerGreen.opacity(0.3), lineWidth: 1)
                        )
                    } else {
                        Circle()
                            .fill(Color.summerGreen.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.summerGreen))
                            )
                            .onAppear {
                                Task {
                                    await loadImageURL(gsURL: photoUrl)
                                }
                            }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.mineShaft)
                Text(age)
                    .font(.system(size: 14))
                    .foregroundColor(Color.mineShaft.opacity(0.7))
            }
            
            Spacer()
            
            rightContent
        }
        .customCardView()
    }
    
    // MARK: - Right Content
    @ViewBuilder
    private var rightContent: some View {
        switch cellType {
        case .schedule(let time):
            Text(time)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.mineShaft)
        case .kidRow:
            Image(systemName: "chevron.right")
                .foregroundColor(Color.mineShaft.opacity(0.5))
                .font(.system(size: 14, weight: .semibold))
        }
    }
    
    // MARK: - Helper Methods
    @MainActor
    private func loadImageURL(gsURL: String) async {
        // Use reusable extension to convert gs:// URL to download URL
        if let downloadURLString = await gsURL.toFirebaseDownloadURL(),
           let url = URL(string: downloadURLString) {
            downloadURL = url
        }
    }
}

// MARK: - Preview
#Preview("Schedule") {
    HomeKidsCellView(
        name: "Emma",
        age: "2 years",
        cellType: .schedule(time: "3:00 PM"),
        photoUrl: nil
    )
    .padding()
}
