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
protocol UserMealUseCaseProtocol {
    func execute(mealId: Int, quantity: Float) async throws -> UserMealResponse
    func delete(mealId: Int) async throws -> UserMealResponse
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
final class AddUserMealUseCase: UserMealUseCaseProtocol {
    private let networkManager = NetworkManager.shared
    
    func execute(mealId: Int, quantity: Float) async throws -> UserMealResponse {
        let endpoint = Endpoint.addUserMeal(mealId: mealId, quantity: quantity)
        
        do {
            let addMealResponse: UserMealResponse = try await networkManager.request(
                endpoint: endpoint,
                method: .post,
                parameters: endpoint.parameters,
                encodingType: .url
            )
            return addMealResponse
        } catch {
            print("AddUserMealUseCase: Ошибка при добавлении блюда: \(error.localizedDescription)")
            throw error
        }
    }
    func delete(mealId: Int) async throws -> UserMealResponse {
        let endpoint = Endpoint.deleteUserMeal(mealId: mealId)
        
        do {
            let addMealResponse: UserMealResponse = try await networkManager.request(
                endpoint: endpoint,
                method: .delete,
                parameters: endpoint.parameters,
                encodingType: .url
            )
            return addMealResponse
        } catch {
            print("AddUserMealUseCase: Ошибка при удалении блюда: \(error.localizedDescription)")
            throw error
        }
    }
}
