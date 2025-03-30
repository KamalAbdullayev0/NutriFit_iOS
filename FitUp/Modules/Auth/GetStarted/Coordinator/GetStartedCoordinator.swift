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
        let getStartedVC = GetStartedController(viewModel: .init(coordinator: self))
        navigationController.setViewControllers([getStartedVC], animated: false)
    }
    
    func showLoginPage() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
        logChildCoordinators("showLoginPagegetstarted")
    }
    
    func showRegisterPage() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        addChildCoordinator(registerCoordinator)
        registerCoordinator.start()
        logChildCoordinators("showRegisterPagegetstarted")
    }
}

