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
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupHorizontalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        // Возвращаем estimatedItemSize для внутреннего CollectionView,
        // чтобы ячейки категорий сами определяли свою ширину по контенту.
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 12 // Промежуток между категориями
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.backgroundColor = .clear
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.register(DisplayCategoryCell.self, forCellWithReuseIdentifier: DisplayCategoryCell.reuseIdentifier)
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        
        contentView.addSubview(horizontalCollectionView)
        NSLayoutConstraint.activate([
            horizontalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // Высота контейнера будет задаваться извне, в SearchViewController через layout.itemSize
        ])
    }
    
    // Вызывается из главного контроллера
    func configure(with categories: [DisplayCategory], selectedIndex: Int) {
        self.categories = categories
        self.selectedCategoryIndex = selectedIndex
        horizontalCollectionView.reloadData() // Перезагружаем данные своей коллекции
        
        // Выделение и прокрутка после перезагрузки
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DisplayCategoryCell.reuseIdentifier, for: indexPath) as? DisplayCategoryCell else {
            fatalError("Cannot create DisplayCategoryCell")
        }
        cell.configure(with: categories[indexPath.item])
        cell.isSelected = (indexPath.item == selectedCategoryIndex) // Устанавливаем состояние
        return cell
    }
    
    
    
    
    // MARK: - UICollectionViewDelegate (для горизонтальной коллекции)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < categories.count else { return }
        let category = categories[indexPath.item]
        
        // Обновляем только если индекс изменился
        if selectedCategoryIndex != indexPath.item {
            let previousIndex = selectedCategoryIndex
            selectedCategoryIndex = indexPath.item
            
            // Обновляем визуально ячейки (не обязательно, т.к. selectItem должен сработать)
            // Но на всякий случай оставим
            if let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? DisplayCategoryCell {
                previousCell.isSelected = false
            }
            if let currentCell = collectionView.cellForItem(at: indexPath) as? DisplayCategoryCell {
                currentCell.isSelected = true
            }
            
            
            // Сообщаем главному контроллеру
            onCategorySelected?(category, indexPath.item)
        }
        // Прокрутка не нужна, т.к. ячейки занимают всю ширину
    }
}
