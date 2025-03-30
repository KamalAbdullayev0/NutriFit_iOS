//
//  Coordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 17.03.25.
//
import UIKit

class Coordinator: NSObject {
    var navigationController: UINavigationController
//    weak var parentCoordinator: Coordinator?
    
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
//        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    func logChildCoordinators(_ message: String) {
        print("\(message). Текущее количество координаторов: \(childCoordinators.count)")
    }
}
