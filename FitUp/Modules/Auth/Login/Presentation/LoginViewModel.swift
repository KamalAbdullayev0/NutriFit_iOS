//
//  LoginViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import Foundation

final class LoginViewModel {
    private weak var coordinator: GetStartedCoordinator?
    
    var username: String = ""
    var password: String = ""
    

    
    func login() {

    }
    
    func goToRegister() {
        print("salam")
        coordinator?.showRegisterPage()
    }
}

