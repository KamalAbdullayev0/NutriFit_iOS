//
//  LoginViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import Foundation

final class LoginViewModel {
    private weak var navigation: AuthFlowNavigation?
    private let loginUseCase: LoginUseCaseProtocol
    
    init(navigation: AuthFlowNavigation, loginUseCase: LoginUseCaseProtocol) {
        self.navigation = navigation
        self.loginUseCase = loginUseCase
    }
    
    @MainActor
    func login(username: String, password: String) async {
        do {
            let response = try await loginUseCase.execute(username: username, password: password)
            print("✅ Login successful. AccessToken: \(response.accessToken)")
            AuthManager.shared.accessToken = response.accessToken
            AuthManager.shared.refreshToken = response.refreshToken
            navigation?.showOnboarding()
        } catch {
            print("❌ Login failed: \(error.localizedDescription)")
        }
    }
    func goToRegister() {
        print("salam")
        navigation?.showRegisterPage()
    }
}

