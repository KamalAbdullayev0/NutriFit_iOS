//
//  LoginViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import Foundation

final class LoginViewModel {
    private weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    var username: String = ""
    var password: String = ""
    
    func login() {
        coordinator?.showOnboarding()
    }
    func goToRegister() {
        print("salam")
        coordinator?.showRegisterPage()
    }
}

