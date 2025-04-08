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
                    showMainFlow()
//        showAuthFlow()
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: self.navigationController)
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
        window.rootViewController = self.navigationController
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator()
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
        window.rootViewController = mainCoordinator.rootViewController
    }
}

