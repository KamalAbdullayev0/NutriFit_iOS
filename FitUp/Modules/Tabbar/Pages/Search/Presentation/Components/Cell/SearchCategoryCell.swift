//
//  DisplayCategoryCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 06.05.25.
//

import UIKit

class SearchCategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchCategoryCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    
    private let indicatorForeground: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(indicatorForeground)
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: indicatorForeground.topAnchor, constant: -6),
            
            
            indicatorForeground.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            indicatorForeground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            indicatorForeground.heightAnchor.constraint(equalToConstant: 4),
            indicatorForeground.widthAnchor.constraint(equalTo: nameLabel.widthAnchor,constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with category: DisplayCategory) {
        nameLabel.text = category.name
        
        //        iconImageView.image = category.icon?.withRenderingMode(.alwaysTemplate)
        
        if let orig = category.icon {
            
            let source = orig
            let thick = orig.thickened(radius: 2.5) ?? source
            iconImageView.image = thick.withRenderingMode(.alwaysTemplate)
        } else {
            iconImageView.image = nil
        }
    }
    override var isSelected: Bool {
        didSet {
            let targetColor: UIColor = isSelected ? .label : .secondaryLabel
            
            UIView.animate(withDuration: 0.20) {
                self.nameLabel.textColor = targetColor
                self.iconImageView.tintColor = targetColor
                self.indicatorForeground.alpha = self.isSelected ? 1 : 0
                self.iconImageView.transform = self.isSelected ? CGAffineTransform(scaleX: 1.25, y: 1.25) : .identity
            }
        }
    }
}
