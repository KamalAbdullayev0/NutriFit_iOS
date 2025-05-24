//
//  SearchUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//
import Foundation

enum MealRequestType: String, CaseIterable {
    case breakfast = "BREAKFAST"
    case lunch = "LUNCH"
    case dinner = "DINNER"
    case snack = "SNACK"
    case dessert = "DESSERT"
    case drink = "DRINK"
}

protocol GetSearchMealUseCase {
    func getMealData(for mealType: MealRequestType) async throws -> MealListResponse
}

final class SearchUseCaseImpl: GetSearchMealUseCase {
    private let networkManager = NetworkManager.shared
    
    func getMealData(for mealType: MealRequestType) async throws -> MealListResponse {
        let endpoint = Endpoint.getMealsByType(mealType: mealType.rawValue)
        do {
            let mealResponse: MealListResponse = try await networkManager.request(
                endpoint: endpoint,           // Передаем наш сконфигурированный Endpoint
                method: .get,                 // HTTPMethod.get
                encodingType: .url            // Указывает, что parameters должны быть URL-закодированы
            )
            return mealResponse
        } catch {
            print("[SearchUseCase] Ошибка при получении данных о блюдах для типа '\(mealType.rawValue)': \(error.localizedDescription)")
            throw error
        }
    }
}

