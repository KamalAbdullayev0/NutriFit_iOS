//
//  TopSearchView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 06.05.25.
//
import UIKit

class TopSearchView: UIView {

    var onSearchAreaTap: (() -> Void)?
    var onFilterButtonTap: (() -> Void)?

    // --- UI Elements ---
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = .label
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What you eat ?"
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Any meals or ingredients"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var filterButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // --- Initialization ---
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // --- Configuration ---
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    // --- Setup ---
    private func setupView() {
        backgroundColor = .clear
        addSubview(containerView)

        containerView.addSubview(searchIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        filterButtonContainer.addSubview(filterButton)
        containerView.addSubview(filterButtonContainer)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            searchIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),

            filterButtonContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            filterButtonContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            filterButtonContainer.widthAnchor.constraint(equalToConstant: 48),
            filterButtonContainer.heightAnchor.constraint(equalToConstant: 48),

            filterButton.centerXAnchor.constraint(equalTo: filterButtonContainer.centerXAnchor),
            filterButton.centerYAnchor.constraint(equalTo: filterButtonContainer.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 36),
            filterButton.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: searchIcon.topAnchor,constant: -8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: filterButtonContainer.leadingAnchor, constant: -12),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        filterButtonContainer.layer.cornerRadius = 24
        containerView.layer.cornerRadius = 32
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchAreaAction))
        containerView.addGestureRecognizer(tapGesture)
    }

    // --- Actions ---
    @objc private func searchAreaAction(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !filterButtonContainer.frame.contains(location) {
            onSearchAreaTap?()
        }
    }

    @objc private func filterButtonAction() {
        onFilterButtonTap?()
    }
}
