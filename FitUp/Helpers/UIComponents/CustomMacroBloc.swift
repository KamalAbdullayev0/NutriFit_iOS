//
//  CustomMacroBloc.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 11.04.25.
//
import UIKit

struct MacroBlock {
    let view: UIView
    let valueLabel: UILabel
}

func CustomMacroBlock(iconName: String,
                     iconTint: UIColor,
                     title: String,
                     value: String,
                     backgroundColor: UIColor) -> MacroBlock {
    let containerView = UIView()
    containerView.backgroundColor = backgroundColor
    containerView.layer.cornerRadius = 15
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    let iconImageView = UIImageView()
    let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
    iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
    iconImageView.tintColor = iconTint
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    titleLabel.textColor = .secondaryLabel
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let valueLabel = UILabel()
    valueLabel.text = value
    valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    valueLabel.textColor = .label
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let textStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    textStackView.axis = .vertical
    textStackView.spacing = 2
    textStackView.alignment = .leading
    textStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, textStackView])
    horizontalStackView.axis = .horizontal
    horizontalStackView.spacing = 8
    horizontalStackView.alignment = .center
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(horizontalStackView)
    
    NSLayoutConstraint.activate([
        horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
        horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        iconImageView.widthAnchor.constraint(equalToConstant: 20)
    ])
    
    return MacroBlock(view: containerView, valueLabel: valueLabel)
}
