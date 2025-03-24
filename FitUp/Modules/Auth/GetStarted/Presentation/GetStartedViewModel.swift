//
//  GetStartedViewModel.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//
import Foundation

class GetStartedViewModel {

    var onLogin: (() -> Void)?
    var onRegister: (() -> Void)?

    func didTapLogin() {
        onLogin?()
    }
    
    func didTapRegister() {
        onRegister?()
    }
}
