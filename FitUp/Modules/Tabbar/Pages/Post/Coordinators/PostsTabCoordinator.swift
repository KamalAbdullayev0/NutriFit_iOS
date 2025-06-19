//
//  PostsTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

final class PostsTabCoordinator: Coordinator {
    
    override func start() {
        let getUserProfileUseCase = GetUserProfileUseCaseImpl()
        let PostVC = ProfileViewController(viewModel: .init(userProfileUseCase: getUserProfileUseCase))
        navigationController.setViewControllers([PostVC], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 0)
    }
}
