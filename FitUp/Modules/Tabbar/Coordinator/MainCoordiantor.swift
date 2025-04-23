//
//  MainCoordiantor.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//
import UIKit

final class MainCoordinator: Coordinator {
    var onLogout: (() -> Void)?
    private var tabBarController: UITabBarController
    
    override init(navigationController: UINavigationController = UINavigationController()) {
        self.tabBarController = UITabBarController()
        super.init(navigationController: navigationController)
        //        navigationController.isNavigationBarHidden = true
    }
    
    
    
    override func start() {
        var childCoordinators: [Coordinator] = []
        let albumsCoordinator = DietCoordinator(navigationController: UINavigationController())
        let photosCoordinator = PhotosTabCoordinator(navigationController: UINavigationController())
        let postsCoordinator = PostsTabCoordinator(navigationController: UINavigationController())
        let usersCoordinator = UsersTabCoordinator(navigationController: UINavigationController())
        addChildCoordinator(usersCoordinator) // bunnan isledi coordinator yaddasdan cixmadi
        usersCoordinator.onLogoutTriggered = { [weak self] in
            self?.onLogout?()
            }
        childCoordinators = [albumsCoordinator, photosCoordinator, postsCoordinator, usersCoordinator]
        
        childCoordinators.forEach { $0.start() }
        
        tabBarController.viewControllers = childCoordinators.map { $0.navigationController }
        configureTabBarAppearance()
    }
    var rootViewController: UIViewController {
        return tabBarController
    }
    
    private func configureTabBarAppearance() {
        let tabBar = tabBarController.tabBar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.normal.iconColor = Resources.Colors.greyDark
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Resources.Colors.greyDark
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = Resources.Colors.black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Resources.Colors.black
        ]
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

