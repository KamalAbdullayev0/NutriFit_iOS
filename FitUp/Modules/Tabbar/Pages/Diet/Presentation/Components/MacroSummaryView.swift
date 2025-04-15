//
//  MacroSummaryView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 12.04.25.
//
import UIKit

class MacroSummaryView: UIView {
    
    private lazy var carbBlock = CustomMacroBlock(iconName: "bread", iconTint: Resources.Colors.brown, title: "Carb", value: "0g", backgroundColor:  Resources.Colors.brown.withAlphaComponent(0.2))
    
    private lazy var proteinBlock = CustomMacroBlock(iconName: "steak", iconTint: Resources.Colors.redColor, title: "Protein", value: "0g", backgroundColor: Resources.Colors.redColor.withAlphaComponent(0.2))
    
    private lazy var fatBlock = CustomMacroBlock(iconName: "olive", iconTint: Resources.Colors.orange, title: "Fat", value: "0g", backgroundColor: Resources.Colors.orange.withAlphaComponent(0.2))
    
    private lazy var macrosStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            carbBlock.view,
            proteinBlock.view,
            fatBlock.view
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(macrosStack)
        NSLayoutConstraint.activate([
            macrosStack.topAnchor.constraint(equalTo: topAnchor),
            macrosStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            macrosStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            macrosStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func update(carbs: Int, protein: Int, fat: Int) {
        carbBlock.valueLabel.text = "\(carbs)g"
        proteinBlock.valueLabel.text = "\(protein)g"
        fatBlock.valueLabel.text = "\(fat)g"
    }
}
