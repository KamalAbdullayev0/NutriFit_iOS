//
//  HeightViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//

import UIKit

class HeightViewModel {
    weak var delegate: OnboardingStepDelegate?
    
    var currentHeight: Int = 170
    let minHeight: Int = 100
    let maxHeight: Int = 250

    var onHeightUpdate: ((Int) -> Void)?

    var numberOfRows: Int {
        return maxHeight - minHeight + 1
    }

    func heightValue(at index: Int) -> Int? {
        let height = minHeight + index
        return (height >= minHeight && height <= maxHeight) ? height : nil
    }

    func index(for height: Int) -> Int? {
        guard height >= minHeight && height <= maxHeight else { return nil }
        return height - minHeight
    }

    func heightSelected(index: Int) {
        if let newHeight = heightValue(at: index) {
            if newHeight != currentHeight {
                currentHeight = newHeight
            }
        }
    }
    func continueButtonTapped() {
        delegate?.moveToNextStep(currentStep: .height, data: currentHeight)
    }
}
