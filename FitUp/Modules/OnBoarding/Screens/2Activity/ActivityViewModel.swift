//
//  Untitled.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class ActivityViewModel {
    weak var delegate: OnboardingStepDelegate?

    func selectActivity() {
        delegate?.moveToNextStep(currentStep: .activity, data: "salam")
    }
}
