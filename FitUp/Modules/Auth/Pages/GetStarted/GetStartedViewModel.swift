//
//  GetStartedViewModel.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import Foundation

class GetStartedViewModel {
    private weak var navigation: AuthFlowNavigation?

    init(navigation: AuthCoordinator) {
        self.navigation = navigation
    }
    
    func didTapLogin() {
        navigation?.showLoginPage()
    }
    
    func didTapRegister() {
        navigation?.showRegisterPage()
    }
}
