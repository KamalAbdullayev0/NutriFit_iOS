//
//  AppCoordinator.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import UIKit

protocol NavigationProtocol: AnyObject {
//    func goHome()
//    func goToProfile()
//    func goToSettings()
}

final class AppCoordinator: Coordinator, NavigationProtocol {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        self.navigationController = navigationController
    }
    
    
    func start() {
        let viewModel = GetStartedViewModel()
        let homeVC = GetStartedView(viewModel: viewModel)
        navigationController.setViewControllers([homeVC], animated: true)
    }
}
//
//    func goHome() {
//        let homeVM = HomeViewModel(navigation: self)
//        let homeVC = HomeViewController(viewModel: homeVM)
//        navigationController.setViewControllers([homeVC], animated: true)
//    }
//    
//    func goToProfile() {
//        let profileVM = ProfileViewModel(navigation: self)
//        let profileVC = ProfileViewController(viewModel: profileVM)
//        navigationController.pushViewController(profileVC, animated: true)
//    }
//    
//    func goToSettings() {
//        let settingsVM = SettingsViewModel(navigation: self)
//        let settingsVC = SettingsViewController(viewModel: settingsVM)
//        navigationController.pushViewController(settingsVC, animated: true)
//    }

