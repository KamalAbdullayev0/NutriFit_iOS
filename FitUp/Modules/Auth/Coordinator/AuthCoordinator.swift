//
//  GetStartedCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

protocol AuthFlowNavigation: AnyObject {
    func start()
    func showLoginPage()
    func showRegisterPage()
    func showOnboarding()
}

class AuthCoordinator: Coordinator, AuthFlowNavigation{
    var onAuthSuccess: (() -> Void)?
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let getStartedVC = GetStartedController(viewModel: .init(navigation: self))
        navigationController.setViewControllers([getStartedVC], animated: false)
    }
     
    func showLoginPage() {
        let loginUseCase = LoginUseCaseImpl()

        let loginVC = LoginController(viewModel: LoginViewModel(navigation: self, loginUseCase: loginUseCase))
//        let loginVC = LoginController(viewModel: .init(navigation: self))
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showRegisterPage() {
        let registerUseCase = RegisterUseCaseImpl()
        
        let registerVC = RegisterController(viewModel: RegisterViewModel(navigation: self, registerUseCase: registerUseCase))
//        let registerVC = RegisterController(viewModel: .init(navigation: self))
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.onFinish = { [weak self] in
                    self?.onAuthSuccess?()
                }
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
        logChildCoordinators("onboardingCoordinator aa")
    }
}

