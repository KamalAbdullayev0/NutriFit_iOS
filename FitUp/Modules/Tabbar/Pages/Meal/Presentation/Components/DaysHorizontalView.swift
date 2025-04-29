// DaysView.swift
// FitUp
//
// Created by Kamal Abdullayev on 15.04.25.
//
import UIKit

protocol DaysHorizontalViewDelegate: AnyObject {
    func daysHorizontalView(_ view: DaysHorizontalView, didSelectDay date: Date, at indexPath: IndexPath)
}

class DaysHorizontalView: UIView {
    weak var delegate: DaysHorizontalViewDelegate?

    private var days: [DayData] = []
    private var selectedDayIndexPath: IndexPath?
    
    
    public private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 80)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        cv.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifier)
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
        fatalError("init(coder:) has not been implemented")
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
        self.collectionView.layoutIfNeeded()

        if let selectedPath = selectedIndexPath, selectedPath.item < self.days.count {
            DispatchQueue.main.async { [weak self] in
                 guard let self = self else { return }
                 guard selectedPath.item < self.collectionView.numberOfItems(inSection: 0) else {
                     return
                 }
                 self.collectionView.selectItem(at: selectedPath, animated: false, scrollPosition: .centeredHorizontally)
            }
        } else if selectedIndexPath != nil {
        }
    }
}

extension DaysHorizontalView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as? DayCell else {
             return UICollectionViewCell()
        }
        guard indexPath.item < days.count else {
             return cell
        }
        let day = days[indexPath.item]
        cell.configure(with: day)
        return cell
    }
}

extension DaysHorizontalView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDayIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        guard indexPath.item < days.count else {
             return
        }
        let selectedDay = days[indexPath.item]
        delegate?.daysHorizontalView(self, didSelectDay: selectedDay.date, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
