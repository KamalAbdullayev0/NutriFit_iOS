//
//  DietUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

protocol UserGetMealsUseCaseProtocol {
    func execute(/*page: Int, size: Int*/) async throws -> UserMealDataResponse
}
final class GetMealsUseCaseImpl: UserGetMealsUseCaseProtocol {
    private let networkManager = NetworkManager.shared // Используем синглтон

    func execute(/*page: Int, size: Int*/) async throws -> UserMealDataResponse {
//        print("[GetMealsUseCase] Executing fetch for page: \(page), size: \(size)")


        // Вызываем NetworkManager
        // Тип ответа <MealResponse> (т.е. PaginatedResponse<Meal>)
        // Метод .get
        // Эндпоинт .meals
        // Параметры для пагинации
        // Кодирование .url (обычно для GET запросов с параметрами)
        let response: UserMealDataResponse = try await networkManager.request(
            endpoint: .user_meal,
            method: .get,
            encodingType: .url      // GET-параметры обычно кодируются в URL
        )

        print("[GetMealsUseCase] Successfully fetched \(response) meals on page \(response)")
        return response
    }
}
