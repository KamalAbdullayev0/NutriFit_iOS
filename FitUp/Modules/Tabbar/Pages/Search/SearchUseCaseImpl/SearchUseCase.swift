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

protocol AddUserMealUseCaseProtocol {

    func execute(mealId: Int, quantity: Float) async throws -> UserMealResponse // ИЗМЕНЕНО: Возвращаемый тип
}

// 2. Обновляем реализацию UseCase
final class AddUserMealUseCase: AddUserMealUseCaseProtocol {
    private let networkManager = NetworkManager.shared

    func execute(mealId: Int, quantity: Float) async throws -> UserMealResponse { // ИЗМЕНЕНО: Возвращаемый тип
        print("AddUserMealUseCase: Добавление блюда ID: \(mealId), Количество: \(quantity)")
        let endpoint = Endpoint.addUserMeal(mealId: mealId, quantity: quantity)

        do {
            // Вызываем networkManager.request, УКАЗЫВАЯ ОЖИДАЕМЫЙ ТИП ОТВЕТА
            let response: UserMealResponse = try await networkManager.request(
                endpoint: endpoint,
                method: .post,
                // Передаем параметры из Endpoint, чтобы NetworkManager использовал их
                parameters: endpoint.parameters,
                encodingType: .url // Как и раньше, для query параметров
            )
            print("AddUserMealUseCase: Блюдо успешно добавлено. Ответ от сервера: \(response)")
            return response // Возвращаем декодированный ответ
        } catch {
            print("AddUserMealUseCase: Ошибка при добавлении блюда: \(error.localizedDescription)")
            throw error
        }
    }
}
