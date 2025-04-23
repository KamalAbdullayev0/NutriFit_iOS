//
//  Endpoint.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.04.25.
//
import Foundation

enum EncodingType {
    case url
    case json
}

enum Endpoint: String {
    case register = "api/v1/auth/sign-up"
    case login = "api/v1/auth/sign-in"
    case refreshToken = "api/v1/auth/refresh-token"
    case getAuthInfo = "api/v1/auth"
    
    case user_info_update = "api/v1/users"
    
    
    
    case user_nutrition = "api/v1/users/nutrition-requirement"
    
    case user_meal = "api/v1/user-meals/by-user"
    
    case user_meal_date_add_remove = "api/v1/user-meals"
    
}










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

