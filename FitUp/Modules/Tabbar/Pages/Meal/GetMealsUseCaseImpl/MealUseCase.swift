//
//  DietUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation

protocol UserGetMealsUseCaseProtocol {
    func usersTotalMeal(for date: Date) async throws -> TotalMealValuesDTO
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO
    func userMealData(for date: Date) async throws -> [UserMealDTO]
}

final class GetMealsUseCaseImpl: UserGetMealsUseCaseProtocol {
    private let networkManager = NetworkManager.shared
    
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func usersTotalMeal(for date: Date) async throws -> TotalMealValuesDTO {
        let dateString = apiDateFormatter.string(from: date)

        let parameters = ["date": dateString]
        let response: UserMealDataResponse = try await networkManager.request(
            endpoint: .user_meal_date_add_remove,
            method: .get,
            parameters: parameters,
            encodingType: .url
        )

        return response.totalMealValuesDTO
    }
    
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO {
        let response: NutritionRequirementsDTO = try await networkManager.request(
            endpoint: .user_nutrition,
            method: .get,
            encodingType: .url
        )

        return response
    }
    
    func userMealData(for date: Date) async throws -> [UserMealDTO] {
        let dateString = apiDateFormatter.string(from: date)

        let parameters = ["date": dateString]
        let response: UserMealDataResponse = try await networkManager.request(
            endpoint: .user_meal_date_add_remove,
            method: .get,
            parameters: parameters,
            encodingType: .url
        )
        return response.userMealDTOS.content
    }
}
