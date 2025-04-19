//
//  RegisterUseCase.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//
protocol RegisterUseCaseProtocol {
    func execute(fullName: String, username: String, password: String) async throws -> AuthResponse
}

final class RegisterUseCaseImpl: RegisterUseCaseProtocol {
    private let networkManager = NetworkManager.shared

    func execute(fullName: String, username: String, password: String) async throws -> AuthResponse {
        let requestBody = RegisterRequest(fullName: fullName, username: username, password: password)
        let params = try requestBody.toDictionary()

        return try await networkManager.request(
            endpoint: .register,
            method: .post,
            parameters: params,
            encodingType: .json
        )
    }
}

