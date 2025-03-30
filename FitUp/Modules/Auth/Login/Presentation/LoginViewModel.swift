//
//  LoginViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import Foundation

final class LoginViewModel {
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    var username: String = ""
    var password: String = ""
    
    func login() {

    }
    func goToRegister() {
        print("salam")
        coordinator?.goToRegister( )
    }
}

