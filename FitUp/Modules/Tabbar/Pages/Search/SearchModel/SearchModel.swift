//
//  SearchModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//

import Foundation


// MARK: - Meal Item
// Структура для одного элемента (блюда) в списке "content"
struct MealItem: Codable{
    let id: Int
    let name: String
    let cal: Double
    let protein: Double
    let fat: Double
    let sugar: Double
    let carbs: Double
    let description: String
    let type: String
    let unitType: MealUnitType
    let image: String?

}
// MARK: - Meal List API Response
// Корневая структура для всего ответа API
struct MealListResponse: Codable {
    let content: [MealItem]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int // Текущий номер страницы (0-индексированный)
    let sort: SortInfo // Информация о сортировке на верхнем уровне
    let first: Bool
    let numberOfElements: Int // Количество элементов на текущей странице
    let empty: Bool
}
