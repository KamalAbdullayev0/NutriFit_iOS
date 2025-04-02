//
//  AgeModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import Foundation



import Foundation

class AgeViewModel {
    weak var delegate: OnboardingStepDelegate?

    private let minAge = 12
    private let maxAge = 100

    private(set) var selectedAge: Int = 30
//    func selectAge() {
//    selected age
//        delegate?.moveToNextStep(currentStep: .age, data: selectedAge)
//    }

    var ageRange: [Int] {
        Array(minAge...maxAge)
    }
    var numberOfRows: Int {
        ageRange.count
    }
    func ageValue(at index: Int) -> Int {
        guard index >= 0 && index < ageRange.count else {
            print("Error: Index out of bounds in ageValue(at:)")
            return minAge
        }
        return ageRange[index]
    }

    func updateSelectedAge(_ newAge: Int) {
        selectedAge = newAge
         print("Selected Age Updated: \(selectedAge)")
    }
    func continueButtonTapped() {
        delegate?.moveToNextStep(currentStep: .age, data: selectedAge)
    }
}
