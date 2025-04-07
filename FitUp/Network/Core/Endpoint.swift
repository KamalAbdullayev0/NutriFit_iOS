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

