//
//  OnboardingCoordinator.swift.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import UIKit

protocol OnboardingStepDelegate: AnyObject {
    func moveToNextStep(currentStep: OnboardingStep, data: Any?)
}

class OnboardingCoordinator: Coordinator {
    var userData = OnboardingUserData()
    
    override func start() {
        navigate(to: .goal)
    }
    
    func navigate(to step: OnboardingStep) {
        let viewController: UIViewController
        
        switch step {
        case .goal:
            let viewModel = GoalViewModel()
            viewModel.delegate = self
            viewController = GoalViewController(viewModel: viewModel)
            
        case .activity:
            let viewModel = ActivityViewModel()
            viewModel.delegate = self
            viewController = ActivityViewController(viewModel: viewModel)
            
        case .age:
            let viewModel = AgeViewModel()
            viewModel.delegate = self
            viewController = AgeViewController(viewModel: viewModel)
            
        case .height:
            let viewModel = HeightViewModel()
            viewModel.delegate = self
            viewController = HeightViewController(viewModel: viewModel)
            
        case .weight:
            let viewModel = WeightViewModel()
            viewModel.delegate = self
            viewController = WeightViewController(viewModel: viewModel)
            
        case .gender:
            let viewModel = GenderViewModel()
            viewModel.delegate = self
            viewController = GenderViewController(viewModel: viewModel)
            
        case .completed:
            finishOnboarding()
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func finishOnboarding() {
        print("Bitdi")
        
        Task {
            await sendDataToBackend()
        }
    }
}

extension OnboardingCoordinator: OnboardingStepDelegate {
    func moveToNextStep(currentStep: OnboardingStep, data: Any?) {
        if let data = data {
            userData.setData(step: currentStep, value: data)
        }
        
        switch currentStep {
        case .goal:
            navigate(to: .activity)
        case .activity:
            navigate(to: .age)
        case .age:
            navigate(to: .height)
        case .height:
            navigate(to: .weight)
        case .weight:
            navigate(to: .gender)
        case .gender:
            navigate(to: .completed)
        case .completed:
            print("salam")
        }
    }
    @MainActor
    private func sendDataToBackend() async {
        guard userData.isComplete else {
            print("❌ Ошибка: Не все данные онбординга собраны. Отправка отменена.")
            return
        }
        print("✅ Данные онбординга собраны: \(userData.toDictionary())")
        let dto = UserUpdateRequestDTO(
            gender: userData.gender,
            age: userData.age,
            height: userData.height,
            weight: userData.weight,
            goal: userData.goal,
            activityLevel: userData.activityLevel
        )
        let updateUserProfileUseCase = UpdateUserProfileUseCase()
        
        do {
            try await updateUserProfileUseCase.execute(dto: dto, imageData: nil, imageMimeType: nil)
        }catch {
            print("❌❌ Ошибка при обновлении профиля через UseCase: \(error)")}
    }
}
