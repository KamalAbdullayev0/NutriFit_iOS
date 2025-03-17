//
//  Coordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 17.03.25.
//
import UIKit

class Coordinator: NSObject {
    var navigationController: UINavigationController  // Убрали `weak` и `?`
    
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
