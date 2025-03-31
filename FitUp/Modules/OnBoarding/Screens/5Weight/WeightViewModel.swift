//
//  WeightViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class WeightViewModel {
    weak var delegate: OnboardingStepDelegate?

    func selectWeight() {
        delegate?.moveToNextStep(currentStep: .weight, data: 70)
    }
}
