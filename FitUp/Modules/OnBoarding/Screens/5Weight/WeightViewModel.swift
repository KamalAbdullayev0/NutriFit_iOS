//
//  WeightViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import UIKit

class WeightViewModel {
     weak var delegate: OnboardingStepDelegate?

    var currentWeight: Int = 50
    let minWeight: Int = 30
    let maxWeight: Int = 150

    var onWeightUpdate: ((Int) -> Void)?

    var numberOfRows: Int {
        return maxWeight - minWeight + 1
    }

    func weightValue(at index: Int) -> Int? {
        let weight = minWeight + index
        return (weight >= minWeight && weight <= maxWeight) ? weight : nil
    }

    func index(for weight: Int) -> Int? {
        guard weight >= minWeight && weight <= maxWeight else { return nil }
        return weight - minWeight
    }

    func weightSelected(index: Int) {
        if let newWeight = weightValue(at: index) {
            if newWeight != currentWeight {
                currentWeight = newWeight
                print("ViewModel: Weight updated to \(currentWeight) kg")

            }
        }
    }
    func continueButtonTapped() {
         delegate?.moveToNextStep(currentStep: .weight, data: currentWeight)
    }
}
