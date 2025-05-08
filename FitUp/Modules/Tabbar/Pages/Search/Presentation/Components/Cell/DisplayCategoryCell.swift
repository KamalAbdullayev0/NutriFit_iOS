//
//  DisplayCategoryCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 06.05.25.
//

import UIKit

class DisplayCategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DisplayCategoryCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.lineBreakMode = .byClipping
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let selectionIndicator: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.systemIndigo
         view.layer.cornerRadius = 1.5
         view.isHidden = true
         return view
     }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(selectionIndicator)
        contentView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: selectionIndicator.topAnchor, constant: -10),

            selectionIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5), // Отступы для индикатора
            selectionIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            selectionIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with category: DisplayCategory) {
        nameLabel.text = category.name
    }

    override var isSelected: Bool {
         didSet {
             nameLabel.textColor = isSelected ? .systemIndigo : .secondaryLabel // Используем цвет индикатора
             nameLabel.font = isSelected ? .systemFont(ofSize: 15, weight: .bold) : .systemFont(ofSize: 15, weight: .medium)
             selectionIndicator.isHidden = !isSelected
         }
     }
}
