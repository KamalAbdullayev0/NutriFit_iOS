//
//  AppCoordinator.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import UIKit


final class AppCoordinator: Coordinator{
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    
    func start() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
}

