//
//  ProfileViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.06.25.
//

final class ProfileViewModel {
    private let userProfileUseCase: GetUserProfileUseCaseProtocol

    
    init(userProfileUseCase: GetUserProfileUseCaseProtocol) {
        self.userProfileUseCase = userProfileUseCase
    }
    
    @MainActor
    func fetchUserProfile() async throws -> UserProfileDTO {
        return try await userProfileUseCase.fetchUserProfile()
    }
    @MainActor
    func fetchUserRequirements() async throws -> NutritionRequirementsDTO {
        async let requirements = userProfileUseCase.userNutritionRequirements()
        return try await requirements
    }
}
