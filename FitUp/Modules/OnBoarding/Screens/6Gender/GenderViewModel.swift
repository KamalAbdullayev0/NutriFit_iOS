//
//  Untitled.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class GenderViewModel {
    weak var delegate: OnboardingStepDelegate?

    func selectGender() {
        delegate?.moveToNextStep(currentStep: .gender, data: "male")
    }
}
