//
//  WeightViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import UIKit

class WeightViewController: UIViewController, UICollectionViewDelegate {

    private var viewModel: WeightViewModel
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private var lastHapticFeedbackWeight: Int?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's your curent weight?"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let selectedWeightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var weightCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 12, height: 200)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HorizontalTickCell.self, forCellWithReuseIdentifier: HorizontalTickCell.identifier)
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

    init(viewModel: WeightViewModel) {
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
        updateSelectedWeightLabel(viewModel.currentWeight)
        lastHapticFeedbackWeight = viewModel.currentWeight
        customButtonBack()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewInsets()
        if !isInitialScrollSet {
             setupInitialScrollPosition()
             isInitialScrollSet = true
        }
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(selectedWeightLabel)
        view.addSubview(weightCollectionView)
        view.addSubview(centralIndicatorView)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            selectedWeightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            selectedWeightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            weightCollectionView.topAnchor.constraint(equalTo: selectedWeightLabel.bottomAnchor, constant: 30),
            weightCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), // От края до края
            weightCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weightCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            centralIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            centralIndicatorView.topAnchor.constraint(equalTo: weightCollectionView.topAnchor),
            centralIndicatorView.bottomAnchor.constraint(equalTo: weightCollectionView.bottomAnchor),
            centralIndicatorView.widthAnchor.constraint(equalToConstant: 4),

            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func setupViewModelCallbacks() {
        viewModel.onWeightUpdate = { [weak self] weight in
            DispatchQueue.main.async {
                self?.updateSelectedWeightLabel(weight)
                self?.scrollToWeight(weight, animated: true)
                self?.lastHapticFeedbackWeight = weight
            }
        }
    }


    private func updateSelectedWeightLabel(_ weight: Int) {
         selectedWeightLabel.text = "\(weight) kg"
    }

    private func configureCollectionViewInsets() {
        guard let layout = weightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let inset = weightCollectionView.bounds.width / 2 - layout.itemSize.width / 2
        weightCollectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

        if !isInitialScrollSet {
             if let index = viewModel.index(for: viewModel.currentWeight) {
                 let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
                 let initialOffsetX = CGFloat(index) * cellWidthWithSpacing - inset
                 weightCollectionView.setContentOffset(CGPoint(x: initialOffsetX, y: 0), animated: false)
             } else {
                 weightCollectionView.setContentOffset(CGPoint(x: -inset, y: 0), animated: false)
             }
         }
    }

    private func setupInitialScrollPosition() {
        view.layoutIfNeeded()
        scrollToWeight(viewModel.currentWeight, animated: false)
        lastHapticFeedbackWeight = viewModel.currentWeight
    }

    private func scrollToWeight(_ weight: Int, animated: Bool) {
        guard let index = viewModel.index(for: weight),
              let layout = weightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            print("Cannot scroll: Weight \(weight) not found or layout issue.")
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let targetOffsetX = CGFloat(indexPath.item) * cellWidthWithSpacing - weightCollectionView.contentInset.left

        weightCollectionView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)

        if !animated {
            updateSelectedWeightLabel(weight)
            lastHapticFeedbackWeight = weight
        }
    }

    private func findCenterIndex() -> Int? {
        guard let layout = weightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return nil }

        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        guard cellWidthWithSpacing > 0 else { return nil }

        let effectiveOffsetX = weightCollectionView.contentOffset.x + weightCollectionView.contentInset.left
        let estimatedIndex = Int(round(effectiveOffsetX / cellWidthWithSpacing))

        let maxIndex = viewModel.numberOfRows - 1
        let validIndex = max(0, min(estimatedIndex, maxIndex))
        return validIndex
    }

    private func snapToCenter() {
        guard let centerIndex = findCenterIndex(),
              let weightValue = viewModel.weightValue(at: centerIndex) else {
             print("Snap failed: Could not find center index or weight value.")
            return
        }
        if weightValue != lastHapticFeedbackWeight {
            lastHapticFeedbackWeight = weightValue
       }
        viewModel.weightSelected(index: centerIndex)
        updateSelectedWeightLabel(weightValue)
        scrollToWeight(weightValue, animated: true)
    }
}

extension WeightViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // <<< Используем HorizontalTickCell >>>
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalTickCell.identifier, for: indexPath) as? HorizontalTickCell else {
            fatalError("Unable to dequeue HorizontalTickCell")
        }

        if let weightValue = viewModel.weightValue(at: indexPath.item) {
            let isMajorTick = (weightValue % 5 == 0)
            let isHalfTickMaybe = (weightValue % 1 == 0 && !isMajorTick)
            cell.configure(weight: weightValue, isMajor: isMajorTick)
        } else {
            cell.configure(weight: 0, isMajor: false)
        }
        return cell
    }
}

extension WeightViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        selectionFeedbackGenerator.prepare() // Готовим вибрацию
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let centerIndex = findCenterIndex(), let currentWeight = viewModel.weightValue(at: centerIndex) { //
           if selectedWeightLabel.text != "\(currentWeight) kg" {
                updateSelectedWeightLabel(currentWeight)
           }
            if currentWeight != lastHapticFeedbackWeight {
                selectionFeedbackGenerator.selectionChanged()
                lastHapticFeedbackWeight = currentWeight
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

class HorizontalTickCell: UICollectionViewCell {
    static let identifier = "HorizontalTickCell"

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
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private var tickHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tickView)
        contentView.addSubview(numberLabel)
        contentView.clipsToBounds = false

        NSLayoutConstraint.activate([
            tickView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tickView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            tickView.widthAnchor.constraint(equalToConstant: 2),

            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: tickView.bottomAnchor, constant: 5),
            numberLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])

        tickHeightConstraint = tickView.heightAnchor.constraint(equalToConstant: 24)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(weight: Int, isMajor: Bool) {
        tickHeightConstraint?.isActive = false

        if isMajor {
            tickView.backgroundColor = .darkGray
            tickHeightConstraint = tickView.heightAnchor.constraint(equalToConstant: 52)
            numberLabel.text = "\(weight)" // Показываем вес
            numberLabel.isHidden = false
        } else {
            tickView.backgroundColor = .lightGray
            tickHeightConstraint = tickView.heightAnchor.constraint(equalToConstant: 24)
            numberLabel.isHidden = true
        }
        tickHeightConstraint?.isActive = true
    }
}
