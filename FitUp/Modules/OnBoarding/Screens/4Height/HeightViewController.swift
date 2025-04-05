//
//  HeightViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//

import UIKit

class HeightViewController: UIViewController, UICollectionViewDelegate {
    private var viewModel: HeightViewModel
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private var lastHapticFeedbackHeight: Int?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's your height?"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let selectedHeightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var heightCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: 12)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VerticalTickCell.self, forCellWithReuseIdentifier: VerticalTickCell.identifier)
        return collectionView
    }()

    private let centralIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var continueButton = CustomButtonContinue { [weak self] in
        self?.viewModel.continueButtonTapped()
    }
    private var isInitialScrollSet = false

    init(viewModel: HeightViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupViewModelCallbacks()
        updateSelectedHeightLabel(viewModel.currentHeight)
        lastHapticFeedbackHeight = viewModel.currentHeight
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewInsets()
        if !isInitialScrollSet {
             setupInitialScrollPosition()
             isInitialScrollSet = true
        }
    }

    // --- Настройка UI ---
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(selectedHeightLabel)
        view.addSubview(heightCollectionView)
        view.addSubview(centralIndicatorView)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            selectedHeightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            selectedHeightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            heightCollectionView.topAnchor.constraint(equalTo: selectedHeightLabel.bottomAnchor, constant: 30),
            heightCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heightCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightCollectionView.heightAnchor.constraint(equalToConstant: 480),

            centralIndicatorView.centerYAnchor.constraint(equalTo: heightCollectionView.centerYAnchor),
            centralIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            centralIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            centralIndicatorView.heightAnchor.constraint(equalToConstant: 3),

            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func setupViewModelCallbacks() {
        viewModel.onHeightUpdate = { [weak self] height in
            DispatchQueue.main.async {
                self?.updateSelectedHeightLabel(height)
                self?.scrollToHeight(height, animated: true)
                self?.lastHapticFeedbackHeight = height
            }
        }
    }


    private func updateSelectedHeightLabel(_ height: Int) {
         selectedHeightLabel.text = "\(height) cm"
    }

    private func configureCollectionViewInsets() {
        guard let layout = heightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let inset = heightCollectionView.bounds.height / 2 - layout.itemSize.height / 2
        heightCollectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)

         if !isInitialScrollSet {
             if let index = viewModel.index(for: viewModel.currentHeight) {
                 let cellHeightWithSpacing = layout.itemSize.height + layout.minimumLineSpacing
                 let initialOffsetY = CGFloat(index) * cellHeightWithSpacing - inset
                 heightCollectionView.setContentOffset(CGPoint(x: 0, y: initialOffsetY), animated: false)
             } else {
                 heightCollectionView.setContentOffset(CGPoint(x: 0, y: -inset), animated: false)
             }
         }
    }

    private func setupInitialScrollPosition() {
        view.layoutIfNeeded()
        scrollToHeight(viewModel.currentHeight, animated: false)
        lastHapticFeedbackHeight = viewModel.currentHeight
    }

    private func scrollToHeight(_ height: Int, animated: Bool) {
        guard let index = viewModel.index(for: height),
              let layout = heightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            print("Cannot scroll: Height \(height) not found or layout issue.")
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        let cellHeightWithSpacing = layout.itemSize.height + layout.minimumLineSpacing
        let targetOffsetY = CGFloat(indexPath.item) * cellHeightWithSpacing - heightCollectionView.contentInset.top

        heightCollectionView.setContentOffset(CGPoint(x: 0, y: targetOffsetY), animated: animated)

        if !animated {
            updateSelectedHeightLabel(height)
            lastHapticFeedbackHeight = height
        }
    }

    private func findCenterIndex() -> Int? {
        guard let layout = heightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return nil }
        let cellHeightWithSpacing = layout.itemSize.height + layout.minimumLineSpacing
        guard cellHeightWithSpacing > 0 else { return nil }

        let effectiveOffsetY = heightCollectionView.contentOffset.y + heightCollectionView.contentInset.top
        let estimatedIndex = Int(round(effectiveOffsetY / cellHeightWithSpacing))

        let maxIndex = viewModel.numberOfRows - 1
        let validIndex = max(0, min(estimatedIndex, maxIndex))
        return validIndex
    }

    private func snapToCenter() {
        guard let centerIndex = findCenterIndex(),
              let heightValue = viewModel.heightValue(at: centerIndex) else {
            return
        }
        if heightValue != lastHapticFeedbackHeight {
            lastHapticFeedbackHeight = heightValue
       }
        viewModel.heightSelected(index: centerIndex)
        updateSelectedHeightLabel(heightValue)
        scrollToHeight(heightValue, animated: true)
    }
}

extension HeightViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalTickCell.identifier, for: indexPath) as? VerticalTickCell else {
            fatalError("Unable to dequeue VerticalTickCell")
        }

        if let heightValue = viewModel.heightValue(at: indexPath.item) {
            let isMajorTick = (heightValue % 10 == 0)
            cell.configure(height: heightValue, isMajor: isMajorTick)
        } else {
            cell.configure(height: 0, isMajor: false)
        }
        return cell
    }
}

extension HeightViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            selectionFeedbackGenerator.prepare()
        }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let centerIndex = findCenterIndex(), let currentHeight = viewModel.heightValue(at: centerIndex) {
           if selectedHeightLabel.text != "\(currentHeight) cm" {
                updateSelectedHeightLabel(currentHeight)
           }
            if currentHeight != lastHapticFeedbackHeight {
                selectionFeedbackGenerator.selectionChanged()
                lastHapticFeedbackHeight = currentHeight
                selectionFeedbackGenerator.prepare()
            }
       }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToCenter()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCenter()
    }
}


class VerticalTickCell: UICollectionViewCell {
    static let identifier = "VerticalTickCell"

    private let tickView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private var tickWidthConstraint: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tickView)
        contentView.addSubview(numberLabel)
        contentView.clipsToBounds = false

        NSLayoutConstraint.activate([
            tickView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tickView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tickView.heightAnchor.constraint(equalToConstant: 2),

            numberLabel.leadingAnchor.constraint(equalTo: tickView.trailingAnchor, constant: 20),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(height: Int, isMajor: Bool) {
        tickWidthConstraint?.isActive = false
        
        if isMajor {
            tickView.backgroundColor = .darkGray
            tickWidthConstraint = tickView.widthAnchor.constraint(equalToConstant: 80)
            numberLabel.text = "\(height)"
            numberLabel.isHidden = false
        } else {
            tickView.backgroundColor = .lightGray
            tickWidthConstraint = tickView.widthAnchor.constraint(equalToConstant: 30)
            numberLabel.isHidden = true
        }
        tickWidthConstraint?.isActive = true
    }
}
