//
//  UsersTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit
final class UsersTabCoordinator: Coordinator {
    
    override func start() {
        let vc = UsersViewController()
        navigationController.setViewControllers([vc], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 3)
    }
}
