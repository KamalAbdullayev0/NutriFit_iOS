//
//  RegistrViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import Foundation

final class RegisterViewModel {
    private weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    var username: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    

    
    func register() {
        coordinator?.showOnboarding()
    }
}

