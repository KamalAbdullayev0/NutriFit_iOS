//
//  RegisterCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

final class RegisterCoordinator: Coordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = RegisterViewModel()
        let registerVC = RegisterController(viewModel: viewModel)
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func registrationSuccessful() {
        navigationController.popViewController(animated: true)
        removeChildCoordinator(self)
    }
}

