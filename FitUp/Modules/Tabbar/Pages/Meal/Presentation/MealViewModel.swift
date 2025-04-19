//
//  DietViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation

final class MealViewModel {
//    private weak var navigation: AuthFlowNavigation?
//    private let loginUseCase: LoginUseCaseProtocol
//    
//    init(navigation: AuthFlowNavigation, loginUseCase: LoginUseCaseProtocol) {
//        self.navigation = navigation
//        self.loginUseCase = loginUseCase
//    }
    private let userMealsUseCase: UserGetMealsUseCaseProtocol
    
    init(userMealsUseCase: UserGetMealsUseCaseProtocol) {
            self.userMealsUseCase = userMealsUseCase
        }
    @MainActor
    func fetchMeals() async {
        do {
            let response = try await userMealsUseCase.execute()
            print("✅ Login successful. AccessToken: \(response)")
        } catch {
            print("❌ Login failed: \(error.localizedDescription)")
        }
    }
}


