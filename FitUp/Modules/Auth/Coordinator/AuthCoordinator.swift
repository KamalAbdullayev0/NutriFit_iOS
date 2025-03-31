//
//  GetStartedCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

class AuthCoordinator: Coordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    func start() {
        let getStartedVC = GetStartedController(viewModel: .init(coordinator: self))
        navigationController.setViewControllers([getStartedVC], animated: false)
    }
    func showLoginPage() {
        let loginVC = LoginController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(loginVC, animated: true)
    }
    func showRegisterPage() {
        let registerVC = RegisterController(viewModel: .init(coordinator: self))
        navigationController.pushViewController(registerVC, animated: true)
    }
    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
        logChildCoordinators("onboardingCoordinator aa")
    }
}

