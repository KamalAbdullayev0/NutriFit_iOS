//
//  MainCoordiantor.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//
import UIKit

final class MainCoordinator: Coordinator {
    private var tabBarController: UITabBarController
    
    
    override init(navigationController: UINavigationController = UINavigationController()) {
        self.tabBarController = UITabBarController()
        super.init(navigationController: navigationController)
//        navigationController.isNavigationBarHidden = true
    }
    
    
    
    override func start() {
        var childCoordinators: [Coordinator] = []
        let albumsCoordinator = AlbumsTabCoordinator(navigationController: UINavigationController())
        let photosCoordinator = PhotosTabCoordinator(navigationController: UINavigationController())
        let postsCoordinator = PostsTabCoordinator(navigationController: UINavigationController())
        let usersCoordinator = UsersTabCoordinator(navigationController: UINavigationController())
        
        childCoordinators = [albumsCoordinator, photosCoordinator, postsCoordinator, usersCoordinator]
        
        childCoordinators.forEach { $0.start() }
        
        tabBarController.viewControllers = childCoordinators.map { $0.navigationController }
        configureTabBarAppearance()
    }
    var rootViewController: UIViewController {
            return tabBarController
        }
    
    private func configureTabBarAppearance() {
        // Кастомизация tabBar
    }
}

