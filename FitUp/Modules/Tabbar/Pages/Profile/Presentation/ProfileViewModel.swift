//
//  ProfileViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.06.25.
//
import UIKit

final class ProfileViewModel {
    private let userProfileUseCase: GetUserProfileUseCaseProtocol
    
    var onLogoutSuccess: (() -> Void)?
    
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
    
    func logout() {
            
            print("ProfileViewModel: Clearing user session data...")
           
            DispatchQueue.main.async {
                self.onLogoutSuccess?()
            }
        }
}
