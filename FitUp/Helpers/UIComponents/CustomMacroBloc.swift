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
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = Resources.Colors.greyBorderColor.cgColor
    
    
    let iconImageView = UIImageView()
//    let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
//    iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
    iconImageView.image = UIImage(named: iconName)

    iconImageView.tintColor = iconTint
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    titleLabel.textColor = iconTint
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let valueLabel = UILabel()
    valueLabel.text = value
    valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    valueLabel.textColor = .label
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let textStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    textStackView.axis = .vertical
    textStackView.spacing = 2
    textStackView.alignment = .leading
    textStackView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(iconImageView)
    containerView.addSubview(textStackView)
    NSLayoutConstraint.activate([
        
        iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
        iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        iconImageView.widthAnchor.constraint(equalToConstant: 24),
        iconImageView.heightAnchor.constraint(equalToConstant: 24),
        
        textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
        textStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

    ])
    
    return MacroBlock(view: containerView, valueLabel: valueLabel)
}
