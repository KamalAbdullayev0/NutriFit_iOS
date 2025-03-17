//
//  GetStartedViewModel.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import Foundation

class GetStartedViewModel {
    var onGetStarted: (() -> Void)?
    
    func didTapGetStarted() {
        onGetStarted?()
    }
}
