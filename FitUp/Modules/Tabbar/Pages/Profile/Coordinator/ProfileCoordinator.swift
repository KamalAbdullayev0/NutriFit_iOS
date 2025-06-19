//
//  UsersTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit
final class ProfileTabCoordinator: Coordinator {
    
    var onLogoutTriggered: (() -> Void)?
    override func start() {
        
        let getUserProfileUseCase = GetUserProfileUseCaseImpl()
        let ProfileVC = ProfileViewController(viewModel: .init(userProfileUseCase: getUserProfileUseCase))

        ProfileVC.onLogoutTapped = { [weak self] in
            self?.onLogoutTriggered?()
            print("UsersTabCoordinator: Logout triggered") // ✅
        }
        navigationController.setViewControllers([ProfileVC], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 3)
    }
}

