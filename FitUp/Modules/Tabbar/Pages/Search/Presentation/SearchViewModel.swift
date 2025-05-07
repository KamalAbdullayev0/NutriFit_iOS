//
//  SearchViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//

import Foundation

final class SearchViewModel {
    private let searchUseCase: SearchUseCaseImpl
    
    init(searchUseCase: SearchUseCaseImpl) {
        self.searchUseCase = searchUseCase
    }
}
