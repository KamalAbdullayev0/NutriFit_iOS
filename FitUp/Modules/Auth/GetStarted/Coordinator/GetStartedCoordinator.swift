//
//  GetStartedCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

class GetStartedCoordinator: Coordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = GetStartedViewModel()
        let getStartedVC = GetStartedController(viewModel: viewModel)
        
        viewModel.onLogin = { [weak self] in
            self?.showLoginPage()
        }
        
        viewModel.onRegister = { [weak self] in
            self?.showRegisterPage()
        }

        navigationController.setViewControllers([getStartedVC], animated: false)
    }
    
    private func showLoginPage() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    
    private func showRegisterPage() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        addChildCoordinator(registerCoordinator)
        registerCoordinator.start()
    }
}

