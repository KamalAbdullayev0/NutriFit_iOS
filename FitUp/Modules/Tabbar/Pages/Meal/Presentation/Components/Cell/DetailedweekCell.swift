//
//  DetailedweekCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 11.04.25.
//

import UIKit
import Foundation

struct DayData {
    let name: String
    let date: Date
    let isToday: Bool
    let dayNumberString: String
}

class DayCell: UICollectionViewCell {
    
    static let identifier = "DayCell"
    
    // --- UI Элементы ---
    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Resources.AppFont.medium.withSize(18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let dateCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .black
         view.layer.shadowColor = UIColor.black.cgColor
         view.layer.shadowOffset = CGSize(width: 0, height: 1)
         view.layer.shadowRadius = 2
         view.layer.shadowOpacity = 0.1
         view.layer.masksToBounds = false
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Resources.AppFont.bold.withSize(20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    // --- Инициализация ---
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(dayNameLabel)
        contentView.addSubview(dateCircleView)
        dateCircleView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dayNameLabel.centerXAnchor.constraint(equalTo: dateCircleView.centerXAnchor),


            dateCircleView.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor, constant: 10),
            dateCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateCircleView.widthAnchor.constraint(equalToConstant: 48),
            dateCircleView.heightAnchor.constraint(equalToConstant: 48),

            dateLabel.centerXAnchor.constraint(equalTo: dateCircleView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: dateCircleView.centerYAnchor),

        ])
    }

    func configure(with day: DayData) {
        dayNameLabel.text = day.name
        dateLabel.text = day.dayNumberString
        updateAppearance()
    }

    override var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                 updateAppearance()
            }
        }
    }

    private func updateAppearance() {
        let selected = self.isSelected
        dateCircleView.backgroundColor = selected ? .black : Resources.Colors.greyBorderColor
        dateLabel.textColor = selected ? .white : Resources.Colors.greyDark

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
             self.dateCircleView.transform = selected ? CGAffineTransform(scaleX: 1.15, y: 1.15) : .identity
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        updateAppearance()
    }
}
