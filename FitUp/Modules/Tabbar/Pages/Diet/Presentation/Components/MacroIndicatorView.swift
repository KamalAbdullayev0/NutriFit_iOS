//
//  MacroIndicatorView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 12.04.25.

import UIKit

class MacroIndicatorView: UIView {

    private lazy var caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.AppFont.bold.withSize(56)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()

    private lazy var kcalTakenLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.AppFont.medium.withSize(18)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kcal taken"
        return label
    }()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.AppFont.medium.withSize(16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0%"
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.progressTintColor = Resources.Colors.orange
        pv.trackTintColor = Resources.Colors.orange.withAlphaComponent(0.2)
        pv.progress = 0.0
        pv.layer.cornerRadius = 6
        pv.clipsToBounds = true
        return pv
    }()
   
    private lazy var totalCaloriesLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.AppFont.medium.withSize(16)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [percentageLabel, progressView, totalCaloriesLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [caloriesLabel, kcalTakenLabel, progressStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressView.heightAnchor.constraint(equalToConstant: 10),
            progressView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.72)
        ])
    }

    func update(currentKcal: Int, totalKcal: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "."
        numberFormatter.decimalSeparator = ","
        numberFormatter.locale = Locale(identifier: "en_US")

        let formattedCurrentCalories = numberFormatter.string(from: NSNumber(value: currentKcal)) ?? "\(currentKcal)"
        let formattedTotalCalories = numberFormatter.string(from: NSNumber(value: totalKcal)) ?? "\(totalKcal)"

        caloriesLabel.text = formattedCurrentCalories
        totalCaloriesLabel.text = "\(formattedTotalCalories)"

        var progressValue: Float = 0.0
        var percentageValue: Int = 0
        if totalKcal > 0 {
            progressValue = Float(currentKcal) / Float(totalKcal)
            percentageValue = Int(progressValue * 100)
        }

        percentageLabel.text = "\(percentageValue)%"
        progressView.setProgress(progressValue, animated: true)
    }
}
