//
//  DietViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation

final class MealViewModel {
    private let userMealsUseCase: UserGetMealsUseCaseProtocol
    
    init(userMealsUseCase: UserGetMealsUseCaseProtocol) {
        self.userMealsUseCase = userMealsUseCase
    }
    
    //    @MainActor
    //    func fetchMeals(
    //        onSuccess: @escaping (TotalMealValuesDTO, NutritionRequirementsDTO) -> Void,
    //        onFailure: @escaping (Error) -> Void
    //    ) async {
    //        do {
    //            let totalMeals = try await userMealsUseCase.userTotalMeal()
    //            let requirements = try await userMealsUseCase.userNutritionRequirements()
    //
    //            print("✅ Meals fetched successfully: \(totalMeals)")
    //            print("✅ Requirements fetched successfully: \(requirements)")
    //            onSuccess(totalMeals, requirements)
    //
    //        } catch {
    //            print("❌ Fetching meals/requirements failed: \(error.localizedDescription)")
    //            onFailure(error)
    //        }
    //    }
    @MainActor
    func fetchMealData(for date: Date) async throws -> (totalMeals: TotalMealValuesDTO, requirements: NutritionRequirementsDTO) {
        async let totalMealsTask = userMealsUseCase.usersTotalMeal(for: date)
        async let requirementsTask = userMealsUseCase.userNutritionRequirements()
        
        let totalMeals = try await totalMealsTask
        let requirements = try await requirementsTask
        
        print("🔵 ViewModel.fetchMealData: Запрос для даты: \(date)")
        // Перед return
        print("🔵 ViewModel.fetchMealData: Получены totalMeals = \(totalMeals), requirements = \(requirements)") // Важно! requirements без даты!
        return (totalMeals, requirements)
        
    }
}



