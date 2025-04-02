//
//  Untitled.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class ActivityViewModel {
    weak var delegate: OnboardingStepDelegate?
    
    let Activity: [String] = [
        "Not very active",
        "Somewhat active",
        "Moderately active",
        "Highly active",
        "Extremely active",
    ]
    
    private(set) var selectedActivity: String? {
        didSet { onSelectionChange?(selectedActivity)}
    }
    
    var onSelectionChange: ((String?) -> Void)?
    
    func toggleGoalSelection(goal: String) {
        selectedActivity = (selectedActivity == goal) ? nil : goal
    }
    
    func clearSelection() {
        selectedActivity = nil
    }
    
    func continueButtonTapped() {
        guard let activity = selectedActivity else {
            return
        }
        delegate?.moveToNextStep(currentStep: .activity, data: activity)
    }
}
