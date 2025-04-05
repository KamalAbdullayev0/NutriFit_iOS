//
//  CustomBackButton.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.04.25.
//
import UIKit

extension UIViewController {

    private static let standardBackButtonSelector = #selector(handleStandardBackButtonTap)

    func customButtonBack() {
       
        guard let navController = navigationController else {
            print("Warning: configureStandardNavigationBar called on a VC without a navigation controller.")
            return
        }
        navController.navigationBar.tintColor = Resources.Colors.greyDark
        guard let backImage = UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)) else {
            print("Warning: Could not create back button image.")
            return
        }
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: UIViewController.standardBackButtonSelector)
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func handleStandardBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}
