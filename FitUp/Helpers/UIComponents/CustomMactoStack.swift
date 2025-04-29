//
//  CustomMactoStack.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 29.04.25.
//

import UIKit

final class CustomMacroStack: UIStackView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    
    init(valueFont: UIFont = .systemFont(ofSize: 14, weight: .medium),
         labelFont: UIFont = .systemFont(ofSize: 12, weight: .regular),
         textColor: UIColor = .label,
         secondaryColor: UIColor = .secondaryLabel) {
        super.init(frame: .zero)
        setupStack()
        configure(valueFont: valueFont, labelFont: labelFont, textColor: textColor, secondaryColor: secondaryColor)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupStack() {
        axis = .vertical
        spacing = 2
        alignment = .center
        addArrangedSubview(valueLabel)
        addArrangedSubview(descriptionLabel)
    }
    
    private func configure(valueFont: UIFont, labelFont: UIFont, textColor: UIColor, secondaryColor: UIColor) {
        valueLabel.font = valueFont
        valueLabel.textColor = textColor
        
        descriptionLabel.font = labelFont
        descriptionLabel.textColor = secondaryColor
    }
    
    // MARK: - Public methods
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }
}
