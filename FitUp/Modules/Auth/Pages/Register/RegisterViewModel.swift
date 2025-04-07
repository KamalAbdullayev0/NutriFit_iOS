//
//  RegistrViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import Foundation

final class RegisterViewModel {
    private weak var navigation: AuthFlowNavigation?
    private let registerUseCase: RegisterUseCaseProtocol
    
    init(navigation: AuthCoordinator,registerUseCase: RegisterUseCaseProtocol) {
        self.navigation = navigation
        self.registerUseCase = registerUseCase
    }
    
    @MainActor
    func register(fullName: String, username: String, password: String) async {
        do {
            let response = try await registerUseCase.execute(fullName: fullName, username: username, password: password)
            print("✅ Login successful. AccessToken: \(response.accessToken)")
            navigation?.showOnboarding()
        } catch {
            print("❌ Login failed: \(error.localizedDescription)")
        }
    }
}

