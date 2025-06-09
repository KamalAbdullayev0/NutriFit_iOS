//
//  GetUserProfileUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 09.06.25.
//

import Foundation

protocol GetUserProfileUseCaseProtocol {
    func fetchUserProfile() async throws -> UserProfileDTO
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO
}

final class GetUserProfileUseCaseImpl: GetUserProfileUseCaseProtocol {
    private let networkManager = NetworkManager.shared
    
    func fetchUserProfile() async throws -> UserProfileDTO {
        let response: UserProfileDTO = try await networkManager.request(
            endpoint: .userAuthMe,
            method: .get,
            encodingType: .url
        )
        return response
    }
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO {
        let response: NutritionRequirementsDTO = try await networkManager.request(
            endpoint: .userNutrition,
            method: .get,
            encodingType: .url
        )
        return response
    }
}
