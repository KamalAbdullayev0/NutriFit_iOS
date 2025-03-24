//
//  LoginCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

final class LoginCoordinator: Coordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = LoginViewModel()
        let loginVC = LoginController(viewModel: viewModel)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func goToRegister() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        addChildCoordinator(registerCoordinator)
        registerCoordinator.start()
    }
    
    func loginSuccessful() {
        // TODO: Transition to the main screen or home page
    }
}

