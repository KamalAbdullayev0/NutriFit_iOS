//
//  AppCoordinator.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import UIKit


final class AppCoordinator: Coordinator{
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        let rootNavigationController = UINavigationController()
        //        rootNavigationController.isNavigationBarHidden = true
        
        super.init(navigationController: rootNavigationController)
    }
    
    override func start() {
        showSplashScreen()
        window.makeKeyAndVisible()
    }
    private func showSplashScreen() {
        let splashVC = SplashScreenViewController()
        splashVC.onComplete = { [weak self] in
            self?.runMainFlowSelector()
        }
        window.rootViewController = splashVC
    }
    private func runMainFlowSelector() {
        let token = AuthManager.shared.accessToken
        if let token, !token.isEmpty {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: self.navigationController)
        authCoordinator.onAuthSuccess = { [weak self] in
            self?.removeChildCoordinator(authCoordinator)
            self?.runMainFlowSelector()
        }
        addChildCoordinator(authCoordinator)
        authCoordinator.start()x
        window.rootViewController = self.navigationController
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.onLogout = { [weak self] in
            print("AppCoordinator: Handling logout") // ✅
            AuthManager.shared.clearTokens()
            self?.removeChildCoordinator(mainCoordinator)
            self?.runMainFlowSelector()
        }
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
        window.rootViewController = mainCoordinator.rootViewController
    }
}

