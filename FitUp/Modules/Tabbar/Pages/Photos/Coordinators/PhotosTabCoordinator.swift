//
//  PhotosTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

final class PhotosTabCoordinator: Coordinator {
    
    override func start() {
        let vc = PhotosViewController()
        navigationController.setViewControllers([vc], animated: false)
        

        navigationController.tabBarItem = UITabBarItem(title: "Activities", image: UIImage(named: "activities"), tag: 2)
    }
}
