//
//  MenuSectionHeaderView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.05.25.
//
import UIKit

class MenuSectionHeaderView: UICollectionReusableView { // Используем хедер из первого примера
    static let reuseIdentifier = "MenuSectionHeaderView"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Resources.AppFont.bold.withSize(28)
        label.textColor = .label
        return label
    }()
    let translateButton: UIButton = {
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
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
             titleLabel.topAnchor.constraint(equalTo: topAnchor),

            translateButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            translateButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16)
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

