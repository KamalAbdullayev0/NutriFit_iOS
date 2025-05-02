//
//  MealHorizontalView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 25.04.25.
//

import UIKit

class MealHorizontalView: UIView {

    private var meals: [UserMealDTO] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 220)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(MealCell.self, forCellWithReuseIdentifier: MealCell.identifier)
        return cv
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 230),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Configuration

    func configure(with meals: [UserMealDTO]) {
        self.meals = meals
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if !meals.isEmpty {
                 self.collectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MealHorizontalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.identifier, for: indexPath) as? MealCell else {
            fatalError("Failed to dequeue MealCell")
        }
        let mealData = meals[indexPath.item]
        cell.configure(with: mealData)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
// MARK: - UICollectionViewDelegate

extension MealHorizontalView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected meal: \(meals[indexPath.item].meal.name)")
    }
}

