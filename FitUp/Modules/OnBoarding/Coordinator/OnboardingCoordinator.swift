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

    func start() {
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
            sendDataToBackend()
        }
    }
    
    private func sendDataToBackend() {
        if let userDataDict = userData.build() {
            print("Backend:", userDataDict)
        } else {
            print("Error")
        }
    }
}
