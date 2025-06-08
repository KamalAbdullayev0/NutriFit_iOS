//
//  ProfileAiTrainerButton.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.06.25.
//


import UIKit

class AITrainerButtonCell: UICollectionViewCell {
    static let reuseIdentifier = "AITrainerButtonCell"
    
    private let buttonLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemPink
        layer.cornerRadius = 12
        
        buttonLabel.text = "★ AI Personal Trainer"
        buttonLabel.textColor = .white
        buttonLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonLabel)
        
        NSLayoutConstraint.activate([
            buttonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
