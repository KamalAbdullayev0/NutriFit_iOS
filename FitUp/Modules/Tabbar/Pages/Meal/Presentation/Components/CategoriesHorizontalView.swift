//
//  CategoriesHorizontalView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 15.04.25.
//
import UIKit

protocol CategoriesHorizontalViewDelegate: AnyObject {
    func categoriesHorizontalView(_ view: CategoriesHorizontalView, didSelectCategory category: CategoryEntity)
}

class CategoriesHorizontalView: UIView {


    weak var delegate: CategoriesHorizontalViewDelegate?

    private var categories: [CategoryEntity] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 12

        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsSelection = true
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with categories: [CategoryEntity]) {
        self.categories = categories
        self.collectionView.reloadData()
    }

    private func animateTap(on view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            view.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
                view.alpha = 1.0
            }
        }
    }
}

extension CategoriesHorizontalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            assertionFailure("Не удалось декьюить CategoryCell в CategoriesHorizontalView")
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesHorizontalView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]

        if let cell = collectionView.cellForItem(at: indexPath) {
            animateTap(on: cell)
        }

        delegate?.categoriesHorizontalView(self, didSelectCategory: selectedCategory)

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

