//
//  DietViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation

final class MealViewModel {
    
    private let userMealsUseCase: UserGetMealsUseCaseProtocol
    private let userProfileUseCase: UserProfileUseCaseProtocol
    
    init(
        userMealsUseCase: UserGetMealsUseCaseProtocol,
        userProfileUseCase: UserProfileUseCaseProtocol
    ) {
        self.userMealsUseCase = userMealsUseCase
        self.userProfileUseCase = userProfileUseCase
    }
    
    @MainActor
    func fetchMealData(for date: Date) async throws -> (totalMeals: TotalMealValuesDTO, requirements: NutritionRequirementsDTO, usermeal: [UserMealDTO]) {
        async let totalMealsTask = userMealsUseCase.usersTotalMeal(for: date)
        async let requirementsTask = userMealsUseCase.userNutritionRequirements()
        async let usermealTask = userMealsUseCase.userMealData(for: date)
        
        let totalMeals = try await totalMealsTask
        let requirements = try await requirementsTask
        let usermeal = try await usermealTask
        
        return (totalMeals, requirements, usermeal)
        
    }
    
    @MainActor
    func fetchUserProfile() async throws -> UserProfileDTO {
        return try await userProfileUseCase.userData()
    }
}
