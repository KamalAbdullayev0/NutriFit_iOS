//
//  OptionCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.06.25.
//
import UIKit

enum CellPosition {
    case first, middle, last, single
}

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
        self.backgroundColor = .white
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
            chevronImageView.widthAnchor.constraint(equalToConstant: 15),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    
    // ---roundCorners
    public func roundCorners(for position: CellPosition, with radius: CGFloat = 12) {
        let path: UIBezierPath
        let corners: UIRectCorner
        
        switch position {
        case .first:
            corners = [.topLeft, .topRight]
        case .middle:
            corners = []
        case .last:
            corners = [.bottomLeft, .bottomRight]
        case .single:
            corners = .allCorners
        }
        
        // Создаем путь с нужными скругленными углами
        path = UIBezierPath(roundedRect: self.bounds,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius))
        
        // Создаем маску и применяем ее к слою ячейки
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    // --- ВАЖНО: Сбрасываем маску при переиспользовании ячейки ---
        override func prepareForReuse() {
            super.prepareForReuse()
            // Если этого не сделать, ячейка сохранит старое скругление при прокрутке
            self.layer.mask = nil
        }
    
    // --- configureCell
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
