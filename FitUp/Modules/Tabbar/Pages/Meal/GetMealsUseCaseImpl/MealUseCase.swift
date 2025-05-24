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
protocol UserProfileUseCaseProtocol {
    func userData() async throws -> UserProfileDTO
}


final class GetMealsUseCaseImpl: UserGetMealsUseCaseProtocol, UserProfileUseCaseProtocol {
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
            endpoint: .userMealDateAddRemove,
            method: .get,
            parameters: parameters,
            encodingType: .url
        )

        return response.totalMealValuesDTO
    }
    
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO {
        let response: NutritionRequirementsDTO = try await networkManager.request(
            endpoint: .userNutrition,
            method: .get,
            encodingType: .url
        )

        return response
    }
    
    func userMealData(for date: Date) async throws -> [UserMealDTO] {
        let dateString = apiDateFormatter.string(from: date)

        let parameters = ["date": dateString]
        let response: UserMealDataResponse = try await networkManager.request(
            endpoint: .userMealDateAddRemove,
            method: .get,
            parameters: parameters,
            encodingType: .url
        )
        return response.userMealDTOS.content
    }
    
    func userData() async throws -> UserProfileDTO {
        let response: UserProfileDTO = try await networkManager.request(
            endpoint: .userAuthMe,
            method: .get,
            encodingType: .url
        )
        return response
    }
}
