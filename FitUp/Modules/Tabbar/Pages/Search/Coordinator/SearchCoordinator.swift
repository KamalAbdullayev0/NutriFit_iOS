//
//  PhotosTabCoordinator.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

final class SearchCoordinator: Coordinator {
    
    override func start() {
        let searchUseCase = MealUseCase()
        let searchvc = SearchViewController(viewModel: .init(mealUseCase: searchUseCase))
        navigationController.setViewControllers([searchvc], animated: false)
        

        navigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "activities"), tag: 2)
    }
//    override func start() {
//        let userMealsUseCase = GetMealsUseCaseImpl()
//        let mealVC = MealViewController(viewModel: .init(userMealsUseCase: userMealsUseCase, userProfileUseCase: userMealsUseCase))
//        navigationController.setViewControllers([mealVC], animated: false)
//        navigationController.tabBarItem = UITabBarItem(title: "Nutrition", image: UIImage(named: "nutrition"), tag: 1)
//    }
}
