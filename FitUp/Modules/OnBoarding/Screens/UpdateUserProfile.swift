//
//  UserDataUpdate.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.04.25.
//

import Foundation
protocol UpdateUserProfileUseCaseProtocol {
    func execute(dto: UserUpdateRequestDTO, imageData: Data?, imageMimeType: String?) async throws
}

class UpdateUserProfileUseCase: UpdateUserProfileUseCaseProtocol {

    private let networkManager = NetworkManager.shared

    func execute(dto: UserUpdateRequestDTO, imageData: Data?, imageMimeType: String?) async throws {
        print("[UpdateUserProfileUseCase] Executing profile update...")
        do {
             let updatedProfile: UserProfileResponseDTO = try await networkManager.uploadProfile(
                endpoint: .user_info_update,
                 dto: dto,
                 imageData: imageData,
                 imageFileName: "profile_update.jpg",
                 imageMimeType: imageMimeType ?? "image/jpeg"
             )
             print("✅ Profile update successful. Updated data: \(updatedProfile)")
         } catch {
             print("❌ Profile update failed: \(error)")
             throw error
         }
    }
}
