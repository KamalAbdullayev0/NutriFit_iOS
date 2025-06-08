//
//  ProfileHeaderView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.06.25.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "ProfileHeaderView"
    
    private lazy var containerView = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var profileImageView = UIImageView().configure {
        $0.image = UIImage(systemName: "person.circle.fill")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 80
        $0.backgroundColor = .systemGray5
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var welcomeLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.textColor = .label
        $0.setContentCompressionResistancePriority(.required, for: .vertical) // sdcnksdd
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var statsStackView = UIStackView().configure {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        $0.alignment = .top /// sdvcdav
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureMockData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with profile: UserProfile) {
        welcomeLabel.text = "Welcome, \(profile.name)!"
        profileImageView.image = profile.avatarImage ?? UIImage(systemName: "person.circle.fill")
        
        // Очищаем старые статистики
        statsStackView.arrangedSubviews.forEach {
            statsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        addStat(value: "\(profile.stats.record)", label: "Record")
        addStat(value: "\(profile.stats.calorie)", label: "Calorie")
        addStat(value: "\(profile.stats.minute)", label: "Minute")
        
        
    }
    // MARK: - Mock Configuration (заглушка)
    private func configureMockData() {
        configure(with: MockUserProfile.defaultProfile)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(welcomeLabel)
        containerView.addSubview(statsStackView)
        
        setupConstraints()
    }
    
    private func addStat(value: String, label: String) {
        let statView = createStatView(value: value, label: label)
        statsStackView.addArrangedSubview(statView)
    }
    
    private func createStatView(value: String, label: String) -> UIView {
        let view = UIView()
        
        let valueLabel = UILabel().configure {
            $0.text = value
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let textLabel = UILabel().configure {
            $0.text = label
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .secondaryLabel // Используем системный цвет для второстепенного текста
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(valueLabel)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: view.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 160),
            profileImageView.heightAnchor.constraint(equalToConstant: 160),
            
            welcomeLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}
