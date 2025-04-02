//
//  Untitled.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class GenderViewModel {
    weak var delegate: OnboardingStepDelegate?
    
    let Activity: [String] = [
        "👦🏻 Male",
        "👩🏻 Female",
    ]
    
    private(set) var selectedGender: String? {
        didSet { onSelectionChange?(selectedGender)}
    }
    
    var onSelectionChange: ((String?) -> Void)?
    
    func toggleGoalSelection(goal: String) {
        selectedGender = (selectedGender == goal) ? nil : goal
    }
    
    func clearSelection() {
        selectedGender = nil
    }
    
    func continueButtonTapped() {
        guard let gender = selectedGender else {
            return
        }
        delegate?.moveToNextStep(currentStep: .gender, data: gender)
    }
}
