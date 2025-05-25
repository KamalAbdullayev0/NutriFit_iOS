//
//  SearchModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//

import UIKit

struct DisplayCategory: Hashable {
    let id = UUID()
    let mealType: MealType
    var name: String { mealType.displayName }
    var icon: UIImage? { mealType.icon }
    
    init(mealType: MealType) {
        self.mealType = mealType
    }
}

// Модель для блюда
struct MenuItem: Hashable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let fatValue: String
    let proteinValue: String
    let carbsValue: String
    let quantityInfo: String?
}

struct MenuSection: Hashable {
    let id = UUID()
    let title: String
    var items: [MenuItem]
}

enum MealType: String, CaseIterable {
    case breakfast = "BREAKFAST"
    case lunch = "LUNCH"
    case dinner = "DINNER"
    case snack = "SNACK"
    case dessert = "DESSERT"
    case drink = "DRINK"
    
    // Для отображения в UI
    var displayName: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        case .dessert: return "Dessert"
        case .drink: return "Drinks"
        }
    }
    
    var apiValue: String {
        return rawValue
    }
    
    var icon: UIImage? {
        return UIImage(named: rawValue) ?? UIImage(systemName: "circle.fill")
    }
}
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
struct MealListResponse: Codable {
    let content: [MealItem]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: SortInfo
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}
