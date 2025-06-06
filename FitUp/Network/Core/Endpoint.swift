//
//  Endpoint.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.04.25.
//
import Foundation

// EncodingType остается без изменений
enum EncodingType {
    case url
    case json
}

// Модифицированный Endpoint enum
enum Endpoint {
    // Статические эндпоинты
    case register
    case login
    case refreshToken
    case getAuthInfo
    case userInfoUpdate          // Рекомендую использовать camelCase для имен кейсов в Swift
    case userNutrition           // Рекомендую использовать camelCase
    case userMealByUser          // Рекомендую использовать camelCase
    case userMealDateAddRemove   // Рекомендую использовать camelCase
    case userAuthMe              // Рекомендую использовать camelCase
    
    // Новый эндпоинт с динамической частью
    case getMealsByType(mealType: String)
    case addUserMeal(mealId: Int, quantity: Float)
    
    // Вычисляемое свойство для получения строки пути
    var path: String {
        switch self {
        case .register:
            return "api/v1/auth/sign-up"
        case .login:
            return "api/v1/auth/sign-in"
        case .refreshToken:
            return "api/v1/auth/refresh-token"
        case .getAuthInfo:
            return "api/v1/auth"
        case .userInfoUpdate:
            return "api/v1/users"
        case .userNutrition:
            return "api/v1/users/nutrition-requirement"
        case .userMealByUser:
            return "api/v1/user-meals/by-user"
        case .userMealDateAddRemove:
            return "api/v1/user-meals"
        case .userAuthMe:
            return "api/v1/auth/me"
            
        case .getMealsByType(let typeValue):
            return "api/v1/meals/type/\(typeValue)"
        case .addUserMeal:
            return "api/v1/user-meals"
        }
    }
    var parameters: [String: Any]? {
            switch self {
            case .addUserMeal(let mealId, let quantity):
                return ["mealId": mealId, "quantity": quantity]
            default:
                return nil
            }
        }
}

// NetworkError остается без изменений
enum NetworkError: Error {
    case invalidResponse
    case unauthorized
    case requestFailed(statusCode: Int, message: String?)
    case decodingError
    case refreshTokenFailed
    
    var debugDescription: String {
        switch self {
        case .invalidResponse:
            return "[NetworkError] Invalid server response"
        case .unauthorized:
            return "[NetworkError] Authorization failed"
        case .requestFailed(let code, let msg):
            return "[NetworkError] Request failed (\(code)): \(msg ?? "No message")"
        case .decodingError:
            return "[NetworkError] Failed to decode response"
        case .refreshTokenFailed:
            return "[NetworkError] Token refresh failed"
        }
    }
}
