//
//  AddChildViewModel.swift
//  Motherboard
//
//  Created by Wanhar on 30/11/25.
//

import Foundation
import FirebaseFirestore
import UIKit

@MainActor
@Observable
class AddChildViewModel: BaseViewModel {
    
    // MARK: - Properties
    var fullname: String = ""
    var nickname: String = ""
    var dob: Date = Date()
    var gender: Gender = .male
    var notesGeneral: String = ""
    var photoUrl: String = ""
    var selectedImage: UIImage?
    var isUploadingImage: Bool = false
    
    // MARK: - Dependencies
    private let kidsRepository: KidsRepository = KidsRepositoryImpl()
    
    // MARK: - Methods
    func saveChild() async {
        guard validateFields() else {
            return
        }
        
        guard let userID = AuthManager.shared.currentUserID else {
            showError(message: Constants.noUserIDAvailable)
            return
        }
        
        await withLoading {
            if let image = selectedImage {
                do {
                    try await uploadImage(image: image)
                    
                    guard !photoUrl.isEmpty else {
                        showError(message: Constants.failedToGetImageURL)
                        return
                    }
                } catch {
                    return
                }
            }
            
            let now = Date()
            let kid = KidsModelResponse(
                fullname: fullname,
                dob: dob,
                gender: gender.rawValue,
                nickname: nickname,
                photoUrl: photoUrl,
                notes: notesGeneral,
                createdAt: now,
                updatedAt: now
            )
            
            do {
                _ = try await kidsRepository.addKid(userID: userID, kid: kid)
                isSuccess = true
            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }
    
    private func validateFields() -> Bool {
        if fullname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showError(message: Constants.pleaseEnterFullname)
            return false
        }
        
        if nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showError(message: Constants.pleaseEnterNickname)
            return false
        }
        
        return true
    }
    
    // MARK: - Camera Image Handling
    func handleCameraImage(_ image: UIImage) {
        selectedImage = image
        photoUrl = "" // Clear previous photo URL when new image is captured
    }
    
    // MARK: - Image Upload
    func uploadImage(image: UIImage) async throws {
        guard let userID = AuthManager.shared.currentUserID else {
            showError(message: Constants.noUserIDAvailable)
            throw NSError(domain: "UploadError", code: -1, userInfo: [NSLocalizedDescriptionKey: Constants.noUserIDAvailable])
        }
        
        isUploadingImage = true
        
        defer {
            isUploadingImage = false
        }
        
        do {
            // Use StorageManager to upload image
            let path = "kids/\(userID)/"
            photoUrl = try await StorageManager.shared.uploadImage(
                image: image,
                path: path
            )
        } catch {
            // Show error message
            if let storageError = error as? StorageError {
                showError(message: storageError.localizedDescription)
            } else {
                showError(message: error.localizedDescription)
            }
            throw error
        }
    }
}

