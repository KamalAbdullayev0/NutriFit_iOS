//
//  MenuSectionHeaderView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.05.25.
//
import UIKit

class MenuSectionHeaderView: UICollectionReusableView { // Используем хедер из первого примера
    static let reuseIdentifier = "MenuSectionHeaderView"
    let titleLabel: UILabel = { /* ... как в примере ... */
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    let translateButton: UIButton = { /* ... как в примере ... */
         let button = UIButton(type: .system)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle("Translate", for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
         button.isHidden = true
         return button
     }()
    // Действие для кнопки (будет установлено извне)
    var translateAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(translateButton)
        translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([ /* ... как в примере ... */
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
             titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
             titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
             translateButton.trailingAnchor.constraint(equalTo: trailingAnchor),
             translateButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
             titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: translateButton.leadingAnchor, constant: -8)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, showTranslate: Bool) { // Добавляем showTranslate
        titleLabel.text = title
        translateButton.isHidden = !showTranslate
    }

    @objc private func translateButtonTapped() {
        translateAction?()
    }
}

