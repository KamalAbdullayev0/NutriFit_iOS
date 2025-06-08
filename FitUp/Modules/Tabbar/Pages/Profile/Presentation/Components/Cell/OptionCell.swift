//
//  OptionCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.06.25.
//
import UIKit

class OptionCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "OptionCollectionCell"
    
    // MARK: - UI Elements
    private lazy var iconImageView = UIImageView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .label
    }
    
    private lazy var titleLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .label
    }
    
    private lazy var subtitleLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    
    private lazy var textStackView = UIStackView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 2
        $0.alignment = .leading
    }
    
    private lazy var chevronImageView = UIImageView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .systemGray3
    }
    private lazy var separatorView = UIView().configure {
          $0.translatesAutoresizingMaskIntoConstraints = false
          $0.backgroundColor = .systemGray4
      }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Чтобы ячейка выглядела как в UITableView, мы можем настроить ее фон.
        // Но с Compositional Layout это будет сделано автоматически.
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(textStackView)
        contentView.addSubview(chevronImageView)
        
        contentView.addSubview(separatorView)

        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 8),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 13),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            separatorView.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5) // Тонкая линия
        ])
    }
    
//    public func configureCell(icon: UIImage?, title: String, subtitle: String = "") {
//            iconImageView.image = icon
//            titleLabel.text = title
//            subtitleLabel.text = subtitle
//            subtitleLabel.isHidden = subtitle.isEmpty
//        }
    // --- ИСПРАВЛЕННЫЙ МЕТОД: принимает модель MenuOption ---
        public func configureCell(with option: MenuOption) {
            iconImageView.image = option.icon
            titleLabel.text = option.title
            
            subtitleLabel.text = option.subtitle
            subtitleLabel.isHidden = option.subtitle?.isEmpty ?? true
        }
        
        // --- НОВЫЙ МЕТОД: для управления видимостью сепаратора ---
        public func setSeparatorVisibility(isHidden: Bool) {
            separatorView.isHidden = isHidden
        }
    
}
