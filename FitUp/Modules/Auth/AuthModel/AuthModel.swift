//
//  AuthModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//
import Foundation

// MARK: - AuthResponse
struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let profileImageUrl: String?
    let type: String
}

// MARK: - AuthLogin
struct LoginRequest: Codable {
    let username: String
    let password: String
}
// MARK: - RegisterRequest
struct RegisterRequest: Codable {
    let fullName: String
    let username: String
    let password: String
    let profileImageUrl: String
    let gender: String
    let age: Int
    let height: Int
    let weight: Int
    let goal: String
    let activityLevel: String

    init(
        fullName: String,
        username: String,
        password: String,
        profileImageUrl: String = "1",
        gender: String = "1",
        age: Int = 1,
        height: Int = 1,
        weight: Int = 1,
        goal: String = "1",
        activityLevel: String = "1"
    ) {
        self.fullName = fullName
        self.username = username
        self.password = password
        self.profileImageUrl = profileImageUrl
        self.gender = gender
        self.age = age
        self.height = height
        self.weight = weight
        self.goal = goal
        self.activityLevel = activityLevel
    }
}
struct UserProfileResponseDTO: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let profileImageUrl: String?
    let gender: String
    let age: Int
    let height: Double
    let weight: Double
    let goal: String
    let activityLevel: String
}
struct UserUpdateRequestDTO: Codable {
    let gender: String?
    let age: Int?
    let height: Int?
    let weight: Int?
    let goal: String?
    let activityLevel: String?
    
    init(
        gender: String? = "MALE",
        age: Int? = 1,
        height: Int? = 1,
        weight: Int? = 1,
        goal: String? = "WEIGHT_LOSS",
        activityLevel: String? = "PASSIVE"
    ) {
        self.gender = gender
        self.age = age
        self.height = height
        self.weight = weight
        self.goal = goal
        self.activityLevel = activityLevel
    }
}
// MARK: - AuthRefreshToken
struct RefreshTokenResponse: Codable {
    let accessToken: String
}
