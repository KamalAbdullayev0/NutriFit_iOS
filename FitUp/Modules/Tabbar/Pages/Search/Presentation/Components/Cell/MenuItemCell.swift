//
//  MenuItemCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.05.25.
//
import UIKit

class MenuItemCell: UICollectionViewCell { // Используем MenuItemCell из первого примера
    static let reuseIdentifier = "MenuItemCell"

    let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .secondarySystemBackground
        iv.image = UIImage(systemName: "photo.on.rectangle.angled") // Placeholder
        iv.tintColor = .tertiaryLabel
        return iv
    }()
    let nameLabel: UILabel = { /* ... как в примере ... */
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    let descriptionLabel: UILabel = { /* ... как в примере ... */
         let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    let priceLabel: UILabel = { /* ... как в примере ... */
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        return label
    }()
    let textStackView: UIStackView = { /* ... как в примере ... */
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear // Фон ячейки прозрачный

        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(priceLabel) // Добавим цену

        contentView.addSubview(textStackView)
        contentView.addSubview(itemImageView)

        let imageSize: CGFloat = 90
        let padding: CGFloat = 0 // Внутренних отступов нет, используем sectionInset
        NSLayoutConstraint.activate([
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            itemImageView.widthAnchor.constraint(equalToConstant: imageSize),
            itemImageView.heightAnchor.constraint(equalToConstant: imageSize),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            textStackView.trailingAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: -12),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
        priceLabel.text = nil
    }

    func configure(with menuItem: MenuItem) {
        nameLabel.text = menuItem.name
        descriptionLabel.text = menuItem.description
        priceLabel.text = menuItem.price
        itemImageView.image = UIImage(named: menuItem.imageName) ?? UIImage(systemName: "fork.knife.circle.fill")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
    }
}
