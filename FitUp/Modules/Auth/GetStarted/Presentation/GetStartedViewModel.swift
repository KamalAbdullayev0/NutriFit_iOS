//
//  GetStartedViewModel.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import Foundation

class GetStartedViewModel {
    weak var coordinator: GetStartedCoordinator?

   
    
    init(coordinator: GetStartedCoordinator) {
        self.coordinator = coordinator
    }
    
    func didTapLogin() {
        coordinator?.showLoginPage()
    }
    
    func didTapRegister() {
        coordinator?.showRegisterPage()
    }
}
