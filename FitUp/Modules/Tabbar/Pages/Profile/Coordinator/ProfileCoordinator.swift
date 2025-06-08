//
//  UsersTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit
final class UsersTabCoordinator: Coordinator {
    
    var onLogoutTriggered: (() -> Void)?
    override func start() {
        
        let vc = ProfileViewController()
//        vc.onLogoutTapped = { [weak self] in
//            self?.onLogoutTriggered?()
//            print("UsersTabCoordinator: Logout triggered") // ✅
//        }
        navigationController.setViewControllers([vc], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 3)
    }
}
