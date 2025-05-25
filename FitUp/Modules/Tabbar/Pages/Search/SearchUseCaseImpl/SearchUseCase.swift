//
//  SearchUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//
import Foundation

protocol GetSearchMealUseCase {
    func getMealData(for mealType: MealType) async throws -> MealListResponse
}

final class SearchUseCaseImpl: GetSearchMealUseCase {
    private let networkManager = NetworkManager.shared
    
    func getMealData(for mealType: MealType) async throws -> MealListResponse {
        let endpoint = Endpoint.getMealsByType(mealType: mealType.apiValue)
        do {
            let mealResponse: MealListResponse = try await networkManager.request(
                endpoint: endpoint,
                method: .get,
                encodingType: .url
            )
            return mealResponse
        } catch {
            print("agilling error': \(error.localizedDescription)")
            throw error
        }
    }
}

