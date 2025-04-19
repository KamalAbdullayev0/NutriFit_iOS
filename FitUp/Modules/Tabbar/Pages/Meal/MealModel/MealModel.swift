//
//  MealModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 17.04.25.
//
struct UserMealDataResponse: Codable {
    let userMealDTOS: UserMealPage // Используем созданную ниже структуру для пагинации
    let totalMealValuesDTO: TotalMealValuesDTO

    // Используем CodingKeys, если имена в Swift отличаются от JSON
    enum CodingKeys: String, CodingKey {
        case userMealDTOS
        case totalMealValuesDTO = "totalMealValuesDTO" // Явно указываем, хотя имя совпадает
    }
}
struct UserMealPage: Codable {
    let content: [UserMealDTO] // Массив содержит UserMealDTO
    let pageable: Pageable // Структура для информации о странице
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int // Текущий номер страницы
    let sort: SortInfo // Структура для информации о сортировке
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}
struct UserMealDTO: Codable, Identifiable { // Добавляем Identifiable для SwiftUI List/ForEach
    let id: Int // Уникальный ID записи UserMeal
    let userId: Int
    let mealId: Int
    let date: String // Можно распарсить в Date, если нужно
    let meal: Meal     // Вложенный объект Meal
    let quantity: Int // Или Double, если количество может быть дробным
}
struct Meal: Codable, Identifiable, Hashable { // Добавляем Hashable, если нужно в коллекциях
    let id: Int       // ID самого блюда
    let name: String
    let cal: Double
    let protein: Double
    let fat: Double
    let sugar: Double
    let carbs: Double
    let description: String
    let type: String // Или используй Enum MealType, как раньше, с кастомным декодером
    let unitType: String // Или используй Enum UnitType, как раньше
    let image: String
}
struct TotalMealValuesDTO: Codable {
    let totalProtein: Double
    let totalCarbs: Double
    let totalCal: Double
    let totalFat: Double
    let totalSugar: Double
}
struct Pageable: Codable {
    let sort: SortInfo
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

struct SortInfo: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}
