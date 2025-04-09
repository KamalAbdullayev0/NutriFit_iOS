//
//  PostsTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

final class PostsTabCoordinator: Coordinator {
    
    override func start() {
        let vc = PostsViewController()
        navigationController.setViewControllers([vc], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 0)
    }
}
