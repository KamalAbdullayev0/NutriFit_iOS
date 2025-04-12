//
//  MacroIndicatorView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 12.04.25.
//
import UIKit

class MacroIndicatorView: UIView {
    
    private lazy var caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()
    
    private lazy var kcalTakenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kcal taken"
        return label
    }()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0%"
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.progressTintColor = .systemOrange
        pv.trackTintColor = UIColor.systemGray4
        pv.progress = 0.0
        pv.layer.cornerRadius = 4
        pv.clipsToBounds = true
        pv.transform = CGAffineTransform(scaleX: 1, y: 3)
        return pv
    }()
    
    private lazy var totalCaloriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()
    
    private lazy var macroStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [percentageLabel, progressView,totalCaloriesLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8 // Reduced spacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [percentageLabel, progressView,totalCaloriesLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8 // Reduced spacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [caloriesLabel, kcalTakenLabel,progressStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
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
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func update(currentKcal: Int, totalKcal: Int) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal

            let formattedCalories = numberFormatter.string(from: NSNumber(value: currentKcal)) ?? "\(currentKcal)"
            caloriesLabel.text = formattedCalories
            totalCaloriesLabel.text = "/ \(numberFormatter.string(from: NSNumber(value: totalKcal)) ?? "\(totalKcal)")"

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

