//
//  DetailedweekCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 11.04.25.
//
// DetailedDayCell.swift
import UIKit
import Foundation

struct DayData {
    let name: String
    let date: Date
    let isToday: Bool
}
class DetailedDayCell: UICollectionViewCell {
    static let identifier = "DetailedDayCell"
    
    private struct Style {
        static let selectedBackgroundColor = UIColor(red: 0.7, green: 0.9, blue: 0.7, alpha: 0.6) // light green
        static let defaultBackgroundColor = UIColor(white: 0.97, alpha: 0.9) // soft off-white
        static let selectedIconColor = UIColor(red: 1.0, green: 0.8, blue: 0.3, alpha: 1.0) // soft yellow-orange
        static let defaultIconColor = UIColor.systemGray3
        static let cornerRadius: CGFloat = 15
    }
//    private struct Style {
//        static let selectedBackgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
//        static let defaultBackgroundColor = UIColor.systemGray5.withAlphaComponent(0.7)
//        static let selectedIconColor = UIColor.systemYellow
//        static let defaultIconColor = UIColor.systemGray
////        static let iconName = "bolt.fill"
//        static let cornerRadius: CGFloat = 15
//    }

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Style.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
//        imageView.image = UIImage(systemName: Style.iconName, withConfiguration: config)
        imageView.tintColor = Style.defaultIconColor
        return imageView
    }()

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .label // Адаптивный цвет текста
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(dayLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),

            dayLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            dayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            dayLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -6)
        ])
    }

    func configure(with day: DayData) {
        dayLabel.text = day.name
         if day.isToday && !isSelected {
             dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
         } else if !isSelected {
              dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
         }
    }
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        if isSelected {
            containerView.backgroundColor = Style.selectedBackgroundColor
            iconImageView.tintColor = Style.selectedIconColor
            dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        } else {
            containerView.backgroundColor = Style.defaultBackgroundColor
            iconImageView.tintColor = Style.defaultIconColor
            let labelIsBold = dayLabel.font.fontDescriptor.symbolicTraits.contains(.traitBold)
            if labelIsBold && containerView.backgroundColor != Style.defaultBackgroundColor {
                 dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            } else if !labelIsBold {
                 dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false 
        dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
}
