//
//  LoginUsecase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//
protocol LoginUseCaseProtocol {
    func execute(username: String, password: String) async throws -> AuthResponse
}

final class LoginUseCaseImpl: LoginUseCaseProtocol {
    private let networkManager = NetworkManager.shared
    
    func execute(username: String, password: String) async throws -> AuthResponse {
        let requestBody = LoginRequest(username: username, password: password)
        let params = try requestBody.toDictionary()
        
        return try await networkManager.request(
            endpoint: .login,
            method: .post,
            parameters: params,
            encodingType: .json
        )
    }
}
