//
//  GoalViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation

class GoalViewModel {
    weak var delegate: OnboardingStepDelegate?
    
    let availableGoals: [String] = [
        "Lose weight",
        "Manage a health condition",
        "Increase weight",
    ]
    
    private(set) var selectedGoal: String? {
        didSet { onSelectionChange?(selectedGoal)}
    }
    
    var onSelectionChange: ((String?) -> Void)?
    
    func toggleGoalSelection(goal: String) {
        selectedGoal = (selectedGoal == goal) ? nil : goal
    }
    
    func clearSelection() {
        selectedGoal = nil
    }
    
    func continueButtonTapped() {
        guard let goalTitle = selectedGoal,
                 let goal = goalFromTitle(goalTitle) else {
               return
           }
        delegate?.moveToNextStep(currentStep: .goal, data: goal.rawValue)
        
    }
}
