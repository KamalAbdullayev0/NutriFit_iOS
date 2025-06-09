//
//  DietViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation

final class MealViewModel {
    private let userMealsUseCase: UserGetMealsUseCaseProtocol
    private let userProfileUseCase: GetUserProfileUseCaseProtocol
    
    init(
        userMealsUseCase: UserGetMealsUseCaseProtocol,
        userProfileUseCase: GetUserProfileUseCaseProtocol
    ) {
        self.userMealsUseCase = userMealsUseCase
        self.userProfileUseCase = userProfileUseCase
    }
    
    @MainActor
    func fetchMealData(for date: Date) async throws -> (totalMeals: TotalMealValuesDTO, requirements: NutritionRequirementsDTO, usermeal: [UserMealDTO]) {
        async let mealDataTask = userMealsUseCase.fetchUserMealData(for: date)
        async let requirementsTask = userMealsUseCase.userNutritionRequirements()
        let mealData = try await mealDataTask
        let requirements = try await requirementsTask
        
        return (mealData.total, requirements, mealData.meals)
        
    }
    
    @MainActor
    func fetchUserProfile() async throws -> UserProfileDTO {
        return try await userProfileUseCase.fetchUserProfile()
    }
}
