//
//  DietCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

final class DietCoordinator: Coordinator {
    
    override func start() {
        let vc = DietViewController()
        navigationController.setViewControllers([vc], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Nutrition", image: UIImage(named: "nutrition"), tag: 1)
    }
}
