//
//  DietCoordinator.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

final class DietCoordinator: Coordinator {
    
//    func showRegisterPage() {
//        let registerUseCase = RegisterUseCase()
//        
//        let registerVC = RegisterController(viewModel: RegisterViewModel(navigation: self, registerUseCase: registerUseCase))
////        let registerVC = RegisterController(viewModel: .init(navigation: self))
//        navigationController.pushViewController(registerVC, animated: true)
//    }
    override func start() {
        let userMealsUseCase = GetMealsUseCaseImpl()
        
        let mealVC = MealViewController(viewModel: .init(userMealsUseCase: userMealsUseCase))
        navigationController.setViewControllers([mealVC], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Nutrition", image: UIImage(named: "nutrition"), tag: 1)
    }
}
