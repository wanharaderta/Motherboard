//
//  ImageUploadView.swift
//  Motherboard
//
//  Created by Wanhar on 29/12/25.
//

import SwiftUI
import PhotosUI

struct ImageUploadView: View {
    @Binding var selectedPhotos: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    var maxSelectionCount: Int = 3
    var minSelectionCount: Int = 1
    var placeholderText: String = Constants.pictureOfMedicationBottle
    var emptyHeight: CGFloat = 170
    var imageSize: CGFloat = 78
    var onRemove: ((Int) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            // Selected Images Preview
            if !selectedImages.isEmpty {
                HStack(alignment: .center, spacing: Spacing.m) {
                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: imageSize, height: imageSize)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            // Remove button
                            Button(action: {
                                onRemove?(index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.red)
                                    .background(Color.white.clipShape(Circle()))
                            }
                            .offset(x: 5, y: 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: emptyHeight)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(Color.green200)
                )
            } else {
                // Empty state - Upload prompt
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: maxSelectionCount,
                    matching: .images
                ) {
                    VStack(spacing: Spacing.xs) {
                        Image("icAttachedImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.pampas)
                        
                        VStack(spacing: 2) {
                            HStack(spacing: 0) {
                                Text(Constants.please)
                                    .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                    .foregroundColor(Color.black200)
                                
                                Text(Constants.tapToUpload)
                                    .appFont(name: .montserrat, weight: .semibold, size: FontSize.title12)
                                    .foregroundColor(Color.black300)
                            }
                            
                            Text(placeholderText)
                                .appFont(name: .montserrat, weight: .reguler, size: FontSize.title12)
                                .foregroundColor(Color.black200)
                        }
                        .padding(.top, Spacing.xxs)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: emptyHeight)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color.green200)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

