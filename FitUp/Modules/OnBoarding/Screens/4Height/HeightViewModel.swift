//
//  HeightViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//

import Foundation

class HeightViewModel {
    weak var delegate: OnboardingStepDelegate?

    func selectHeight() {
        delegate?.moveToNextStep(currentStep: .height, data: 175)
    }
}
