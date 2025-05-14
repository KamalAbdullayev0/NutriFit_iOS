//
//  CategoryContainerCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.05.25.
//
import UIKit

class CategoryContainerCell: UICollectionViewCell,
                             UICollectionViewDataSource,
                             UICollectionViewDelegate {
    
    static let reuseIdentifier = "CategoryContainerCell"
    
    private var horizontalCollectionView: UICollectionView!
    private var categories: [DisplayCategory] = []
    private var selectedCategoryIndex: Int = 0
    var onCategorySelected: ((DisplayCategory, Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHorizontalCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let trackView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.secondaryLabel.withAlphaComponent(0.1)
        return v
    }()
    
    private func setupHorizontalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 24
        //        layout.minimumInteritemSpacing = 24 // vertical siralma ucun
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.backgroundColor = .clear
        
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.register(SearchCategoryCell.self, forCellWithReuseIdentifier: SearchCategoryCell.reuseIdentifier)
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        
        
        
        contentView.addSubview(trackView)
        contentView.addSubview(horizontalCollectionView)
        NSLayoutConstraint.activate([
            trackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -17),
            trackView.heightAnchor.constraint(equalToConstant: 4),
            
            horizontalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    // Вызывается из главного контроллера
    func configure(with categories: [DisplayCategory], selectedIndex: Int) {
        self.categories = categories
        self.selectedCategoryIndex = selectedIndex
        horizontalCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.selectAndScrollToItem(at: selectedIndex)
        }
    }
    
    private func selectAndScrollToItem(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        let path = IndexPath(item: index, section: 0)
        // Проверяем layout и bounds перед scroll/select
        horizontalCollectionView.layoutIfNeeded()
        guard horizontalCollectionView.bounds.width > 0 else {
            print("Horizontal collection view has zero width, cannot select/scroll.")
            return
        }
        // Проверяем, что ячейка существует
        guard horizontalCollectionView.numberOfItems(inSection: 0) > index else {
            print("Index \(index) is out of bounds for horizontal collection view.")
            return
        }
        horizontalCollectionView.selectItem(at: path, animated: false, scrollPosition: [])
        horizontalCollectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    
    
    // MARK: - UICollectionViewDataSource (для горизонтальной коллекции)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // Всегда одна секция для категорий
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCategoryCell.reuseIdentifier, for: indexPath) as? SearchCategoryCell else {
            fatalError("Cannot create DisplayCategoryCell")
        }
        cell.configure(with: categories[indexPath.item])
        cell.isSelected = (indexPath.item == selectedCategoryIndex) // Устанавливаем состояние
        return cell
    }
    
    
    
    
    // MARK: - UICollectionViewDelegate (для горизонтальной коллекции)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < categories.count else { return }
        let selectedCategoryObject = categories[indexPath.item]
        
        
        if selectedCategoryIndex != indexPath.item {
                   if let previousCell = collectionView.cellForItem(at: IndexPath(item: selectedCategoryIndex, section: 0)) as? SearchCategoryCell {
                       previousCell.isSelected = false
                   }
                   selectedCategoryIndex = indexPath.item // Обновляем текущий индекс
               }
               
               // Обновляем текущую выбранную ячейку (или повторно, если та же)
               if let currentCell = collectionView.cellForItem(at: indexPath) as? SearchCategoryCell {
                   currentCell.isSelected = true
               }

               onCategorySelected?(selectedCategoryObject, indexPath.item)
               collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
           }
}

