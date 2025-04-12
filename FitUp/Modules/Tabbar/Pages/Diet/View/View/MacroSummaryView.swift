//
//  MacroSummaryView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 12.04.25.
//
// MacroSummaryView.swift
import UIKit

class MacroSummaryView: UIView {
    
    private lazy var carbBlock = CustomMacroBlock(iconName: "leaf.fill", iconTint: .systemYellow, title: "Carb", value: "0g", backgroundColor: UIColor.systemYellow.withAlphaComponent(0.15))
    
    private lazy var proteinBlock = CustomMacroBlock(iconName: "flame.fill", iconTint: .systemRed, title: "Protein", value: "0g", backgroundColor: UIColor.systemRed.withAlphaComponent(0.15))
    
    private lazy var fatBlock = CustomMacroBlock(iconName: "drop.fill", iconTint: .systemOrange, title: "Fat", value: "0g", backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15))
    
    private lazy var macrosStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            carbBlock.view,
            proteinBlock.view,
            fatBlock.view
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10 // Настрой по дизайну
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
