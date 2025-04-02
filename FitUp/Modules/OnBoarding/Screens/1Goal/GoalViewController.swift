//
//  GoalViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//

import UIKit

class GoalViewController: UIViewController {
    
    private let viewModel: GoalViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "I want to.."
        label.font = Resources.AppFont.bold.withSize(30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var goalsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "you can choose one"
        label.textAlignment = .center
        label.font = Resources.AppFont.light.withSize(18)
        return label
    }()
    
    private lazy var continueButton = CustomButtonContinue { [weak self] in
               self?.viewModel.continueButtonTapped()
    }
    
    init(viewModel: GoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createGoalButtons()
        setupViewModelCallbacks()
        setupGestureRecognizer()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(goalsStackView)
        view.addSubview(infoLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            goalsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            goalsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            goalsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            infoLabel.topAnchor.constraint(equalTo: goalsStackView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func createGoalButtons() {
        goalsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.availableGoals.forEach { goal in
            let button = GoalButton(title: goal, height: 60) { [weak self] in
                self?.viewModel.toggleGoalSelection(goal: goal)
            }
            goalsStackView.addArrangedSubview(button)
        }
    }
    
    
    private func setupViewModelCallbacks() {
        viewModel.onSelectionChange = { [weak self] selectedGoal in
            DispatchQueue.main.async {
                self?.updateButtonsAppearance(selectedGoal: selectedGoal)
            }
        }
    }
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleBackgroundTap)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateButtonsAppearance(selectedGoal: String?) {
        goalsStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else {
                return
            }
            guard var config = button.configuration, let title = config.title else {
                 return
            }
            let isSelected = (title == selectedGoal)
            config.baseBackgroundColor = isSelected ? Resources.Colors.redColor : Resources.Colors.greyChooseColor
            config.baseForegroundColor = isSelected ? .white : .black
            button.configuration = config
            button.isSelected = isSelected
        }
    }
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        let isGoalButtonTapped = goalsStackView.arrangedSubviews.contains { $0.frame.contains(tapLocation) }
        let isContinueButtonTapped = continueButton.frame.contains(tapLocation)
        
        if !isGoalButtonTapped && !isContinueButtonTapped {
            viewModel.clearSelection()
        }
    }
}

