//
//  AgeModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class AgeViewModel {
    weak var delegate: OnboardingStepDelegate?
    
    func selectAge() {
        delegate?.moveToNextStep(currentStep: .age, data: 25)
    }
}

