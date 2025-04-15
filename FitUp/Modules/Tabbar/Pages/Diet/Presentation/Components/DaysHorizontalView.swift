//
//  DaysView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 15.04.25.
//
import UIKit

protocol DaysHorizontalViewDelegate: AnyObject {
    func daysHorizontalView(_ view: DaysHorizontalView, didSelectDay date: Date, at indexPath: IndexPath)
}

class DaysHorizontalView: UIView {

    weak var delegate: DaysHorizontalViewDelegate?

    private var days: [DayData] = []
    private var selectedDayIndexPath: IndexPath?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 70)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(DetailedDayCell.self, forCellWithReuseIdentifier: DetailedDayCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
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

    func configure(with days: [DayData], selectedIndexPath: IndexPath?) {
        self.days = days
        self.selectedDayIndexPath = selectedIndexPath
        self.collectionView.reloadData()

        
        if let selectedPath = selectedIndexPath {
            DispatchQueue.main.async {
                self.collectionView.selectItem(at: selectedPath, animated: false, scrollPosition: .centeredHorizontally)
                 if let cell = self.collectionView.cellForItem(at: selectedPath) {
                     cell.isSelected = true
                 }
            }
        }
    }


}

// MARK: - UICollectionViewDataSource
extension DaysHorizontalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedDayCell.identifier, for: indexPath) as? DetailedDayCell else {
            fatalError("Unable to dequeue DetailedDayCell in DaysHorizontalView")
        }
        let day = days[indexPath.item]
        cell.configure(with: day)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DaysHorizontalView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == selectedDayIndexPath { return }

        let previouslySelectedIndexPath = selectedDayIndexPath
        selectedDayIndexPath = indexPath

        var indexPathsToReload: [IndexPath] = []
        if let previous = previouslySelectedIndexPath {
            indexPathsToReload.append(previous)
        }
        indexPathsToReload.append(indexPath)
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: indexPathsToReload)
        }) { [weak self] _ in
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
             if let cell = self?.collectionView.cellForItem(at: indexPath) {
                 cell.isSelected = true
             }
        }

        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        let selectedDay = days[indexPath.item]
        delegate?.daysHorizontalView(self, didSelectDay: selectedDay.date, at: indexPath)
    }

   
     func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
         return indexPath != selectedDayIndexPath
     }
}
