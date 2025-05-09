//
//  SearchViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 06.05.25.
//
import UIKit

// MARK: - Главный ViewController
class SearchViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let viewModel: SearchViewModel
    private let topSearchView = TopSearchView()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // --- Lifecycle & Setup ---
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTopSearchView()
        configureCollectionView()
        registerCellsAndHeaders()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTopSearchView() {
        view.addSubview(topSearchView)
        topSearchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            topSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topSearchView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        topSearchView.onSearchAreaTap = {
            print("Search tapped")
        }
        
        topSearchView.onFilterButtonTap = {
            print("Filter tapped")
        }
        
    }
    
    private func configureCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 72, left: 16, bottom: 0, right: 16)
    }
    
    private func registerCellsAndHeaders() {
        collectionView.register(CategoryContainerCell.self, forCellWithReuseIdentifier: CategoryContainerCell.reuseIdentifier)
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
        collectionView.register(MenuSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MenuSectionHeaderView.reuseIdentifier)
    }
    
    
    
    // --- Обработка выбора категории ---
    private func didSelectMealCategory(_ category: DisplayCategory, at index: Int) {
        print("[ViewController] Category selected: \(category.name) at index \(index)")
        // Просто сообщаем ViewModel о выборе
        viewModel.selectCategory(at: index)
        // Обновление UI произойдет через замыкание onDataChanged
    }
    private func setupBinding() {
        viewModel.onDataChanged = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // --- Actions ---
    @objc private func backButtonTapped() {
        print("salam")
    }
    @objc private func moreButtonTapped() {
        print("More button tapped")
    }
    private func addItemToBasket(_ menuItem: MenuItem) {
        print("Добавление в корзину: \(menuItem.name)")
    }
}


extension SearchViewController /* : UICollectionViewDataSource */ { // Можно убрать повторное объявление протокола
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.numberOfItemsInMenuSection(at: section)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryContainerCell.reuseIdentifier, for: indexPath) as? CategoryContainerCell else {
                fatalError("Cannot create CategoryContainerCell")
            }
            cell.configure(with: viewModel.mealCategories, selectedIndex: viewModel.selectedCategoryIndex)
            
            cell.onCategorySelected = { [weak self] (_, index) in
                self?.viewModel.selectCategory(at: index)
            }
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {
                fatalError("Cannot create MenuItemCell - Check registration and identifier")
            }
            if let menuItem = viewModel.menuItem(at: indexPath) {
                cell.configure(with: menuItem)
            } else {
                // Обработка ошибки, если ViewModel вернул nil (быть не должно при правильной логике)
                print("Error: Could not get menu item from ViewModel for indexPath: \(indexPath)")
                cell.configure(with: MenuItem(name: "Error", description: "ViewModel Error", price: "", imageName: ""))
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected supplementary view kind: \(kind)")
        }
        guard indexPath.section > 0 else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MenuSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? MenuSectionHeaderView else {
            fatalError("Failed to dequeue MenuSectionHeaderView")
        }
        
        guard let sectionData = viewModel.menuSection(at: indexPath.section) else {
            header.configure(title: "Error", showTranslate: false) // Обработка ошибки
            return header
        }
        
        // Скрываем хедер для пустых секций (проверяем актуальные данные из ViewModel)
        guard !sectionData.items.isEmpty else {
            header.configure(title: "", showTranslate: false)
            return header
        }
        
        let showTranslate = (indexPath.section == 1) // Пример логики
        header.configure(title: sectionData.title, showTranslate: showTranslate)
        header.translateAction = {
            print("Нажата кнопка Translate для секции: \(sectionData.title)")
            // Можно вызвать метод ViewModel: viewModel.translateSection(sectionData)
        }
        return header
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController /* : UICollectionViewDelegateFlowLayout */ {
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            // Ячейка-контейнер категорий
            return CGSize(width: collectionView.bounds.width, height: 55) // Полная ширина
        } else {
            // Ячейка блюда
            return CGSize(width: collectionView.bounds.width - 32, height: 110)
        }
    }
    
    // Размер хедера секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section > 0 else {
            return .zero
        }
        
        // --- ИСПРАВЛЕНО: Получаем данные из ViewModel ---
        // Пытаемся получить секцию из ViewModel по индексу секции коллекции
        guard let sectionData = viewModel.menuSection(at: section), // Запрашиваем у ViewModel
              !sectionData.items.isEmpty // Проверяем, что в секции (уже отфильтрованной в ViewModel) есть элементы
        else {
            // Если ViewModel не вернул секцию или она пуста, хедер не нужен.
            return .zero
        }
        // Стандартный размер хедера
        let availableWidth = collectionView.bounds.width - 32
        return CGSize(width: availableWidth, height: 44)
    }
}

// Отступы для секции
func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    insetForSectionAt section: Int) -> UIEdgeInsets {
    
    if section == 0 {
        // Достаточно одного safe-area + своего небольшого отступа
        let topPadding = collectionView.adjustedContentInset.top + 10
        return UIEdgeInsets(top: topPadding, left: 0, bottom: 10, right: 0)
    } else {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
}

// Минимальное вертикальное расстояние между ячейками
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return section == 0 ? 0 : 10
}


// MARK: - UICollectionViewDelegate (Swipe Actions & Selection)
extension SearchViewController /* : UICollectionViewDelegate */ {
    
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Получаем menuItem от ViewModel для передачи в action
        guard let menuItem = viewModel.menuItem(at: indexPath) else { return nil }
        
        let addAction = UIContextualAction(style: .normal, title: "Əlavə et") { [weak self] (_, _, completion) in
            // Вызываем метод контроллера, который вызовет ViewModel
            self?.addItemToBasket(menuItem)
            completion(true)
        }
        addAction.backgroundColor = .systemGreen
        addAction.image = UIImage(systemName: "plus.circle.fill")
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Получаем menuItem от ViewModel, если нужно передать дальше
        guard let menuItem = viewModel.menuItem(at: indexPath) else { return }
        print("Нажата ячейка блюда: \(menuItem.name)")
        // viewModel.showDetails(for: menuItem) // Пример вызова ViewModel
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
}
