//
//  DietUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation

protocol UserGetMealsUseCaseProtocol {
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO
    func fetchUserMealData(for date: Date) async throws -> (meals: [UserMealDTO], total: TotalMealValuesDTO)

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
    
    func userNutritionRequirements() async throws -> NutritionRequirementsDTO {
        let response: NutritionRequirementsDTO = try await networkManager.request(
            endpoint: .userNutrition,
            method: .get,
            encodingType: .url
        )
        return response
    }
    func fetchUserMealData(for date: Date) async throws -> (meals: [UserMealDTO], total: TotalMealValuesDTO) {
        let dateString = apiDateFormatter.string(from: date)
        let parameters = ["date": dateString]
        
        let response: UserMealDataResponse = try await networkManager.request(
            endpoint: .userMealDateAddRemove,
            method: .get,
            parameters: parameters,
            encodingType: .url
        )
        return (meals: response.userMealDTOS.content, total: response.totalMealValuesDTO)
    }
}
