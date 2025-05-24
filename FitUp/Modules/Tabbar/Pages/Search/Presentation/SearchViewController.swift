//
//  SearchViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 06.05.25.
//
import UIKit
import SwipeCellKit

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
            topSearchView.heightAnchor.constraint(equalToConstant: 72)
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
        collectionView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
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
            
            cell.onCategorySelected = { [weak self] (selectedCategory, indexInHorizontalScroll) in
                guard let self = self else { return }
                
                // 1. Сообщаем ViewModel о выборе (обновит selectedCategoryIndex и вызовет onDataChanged)
                self.viewModel.selectCategory(at: indexInHorizontalScroll)
                
                // 2. Получаем целевой индекс секции из ViewModel для прокрутки
                if let targetSectionToScroll = self.viewModel.sectionIndexToScroll(forCategory: selectedCategory) {
                    // Убедимся, что такая секция существует
                    guard targetSectionToScroll < self.collectionView.numberOfSections else {
                        print("Error: Target section \(targetSectionToScroll) is out of bounds.")
                        return
                    }
                    
                    // 3. Прокручиваем UICollectionView
                    let targetIndexPath = IndexPath(item: 0, section: targetSectionToScroll)
                    
                    // Проверяем, есть ли хедер или элементы для корректной прокрутки
                    let numberOfItems = self.collectionView(collectionView, numberOfItemsInSection: targetSectionToScroll)
                    let headerSize = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForHeaderInSection: targetSectionToScroll)
                    
                    if numberOfItems > 0 {
                        self.collectionView.scrollToItem(at: targetIndexPath, at: .top, animated: true)
                    } else if headerSize.height > 0 {
                        self.collectionView.scrollToItem(at: targetIndexPath, at: .top, animated: true)
                    } else {
                        print("Section \(targetSectionToScroll) is empty and has no header; cannot scroll effectively.")
                    }
                } else {
                    print("Could not find section to scroll to for category: \(selectedCategory.name)")
                }
            }
            return cell
        } else {
            // ... (код для MenuItemCell без изменений) ...
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {
                fatalError("Cannot create MenuItemCell - Check registration and identifier")
            }
            cell.delegate = self
            if let menuItem = viewModel.menuItem(at: indexPath) {
                cell.configure(with: menuItem)
            } else {
                            // ИСПРАВЛЯЕМ ЗАГЛУШКУ:
                            // Убедись, что поля description и price действительно убраны из MenuItem,
                            // если да, то удали их и из этого инициализатора.
                            // Если они остались, то их нужно будет передать.
                            // Я оставлю их закомментированными, как в твоей последней структуре MenuItem.
                            let errorMenuItem = MenuItem(
                                name: "Error",
                                description: "",
                                // description: "ViewModel Error", // Если это поле удалено из MenuItem
                                // price: "",                   // Если это поле удалено из MenuItem
                                imageName: "",                 // Путь к плейсхолдеру или пустая строка
                                fatValue: "N/A",
                                proteinValue: "N/A",
                                carbsValue: "N/A",
                                quantityInfo: nil              // или " "
                            )
                            cell.configure(with: errorMenuItem)
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
            return CGSize(width: collectionView.bounds.width, height: 100) // Полная ширина
        } else {
            // Ячейка блюда
            return CGSize(width: collectionView.bounds.width, height: 150)
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
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    // Отступы для секции
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0)
        } else {
            return UIEdgeInsets(top: 0,    // ↗︎ пространство над секцией
                                left: 0,
                                bottom: 30, // ↙︎ пространство под секцией
                                right: 0)
        }
    }
    
    // Минимальное вертикальное расстояние между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 0
    }
}


// MARK: - UICollectionViewDelegate (Swipe Actions & Selection)
extension SearchViewController /* : UICollectionViewDelegate */ {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SearchViewController: didSelectItemAt - collectionView.delegate is \(String(describing: collectionView.delegate))")
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

extension SearchViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        editActionsOptionsForItemAt indexPath: IndexPath,
                        for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        // .drag — кнопки идут за пальцем
        options.transitionStyle = .border
        // отступ между кнопками
        options.buttonSpacing = 4
        // .selection — полный свайп сразу выполняет действие
        options.expansionStyle = .selection
        
        
        options.expansionDelegate   = ScaleAndAlphaExpansion.default
        
        if orientation == .left {
                    // ЛЕВЫЙ СВАЙП (избранное) - более деликатное поведение
                    options.expansionStyle = SwipeExpansionStyle(
                        target: .percentage(0.4), // Активация при 40% от ширины экрана
                        additionalTriggers: [
                            .touchThreshold(0.25), // Дополнительный триггер при касании в 25% от края
                            .overscroll(15) // Триггер при перескролле на 15 пикселей
                        ],
                        elasticOverscroll: false, // Эластичное поведение при перескролле
                        completionAnimation: .bounce // Отскок назад после действия
                    )
                    
                } else if orientation == .right {
                    // ПРАВЫЙ СВАЙП (добавление в корзину) - более агрессивное поведение
                    options.expansionStyle = SwipeExpansionStyle(
                        target: .percentage(0.6), // Активация при 60% от ширины экрана
                        additionalTriggers: [
                            .touchThreshold(0.7), // Триггер при касании в 70% от края
                            .overscroll(20) // Триггер при перескролле на 20 пикселей
                        ],
                        elasticOverscroll: false,
                        completionAnimation: .fill(.automatic(.reset, timing: .with)) // Заполнение с автосбросом
                    )
                }
        return options

    }
    func collectionView(_ collectionView: UICollectionView,
                            editActionsForItemAt indexPath: IndexPath,
                            for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
            // Проверяем валидность индекса и получаем элемент меню
            guard indexPath.section > 0,
                  let menuItem = viewModel.menuItem(at: indexPath) else {
                return nil
            }
            
            switch orientation {
            case .right:
                return createRightSwipeActions(for: menuItem, at: indexPath)
            case .left:
                return createLeftSwipeActions(for: menuItem, at: indexPath)
            @unknown default:
                return nil
            }
        }
    
    private func createRightSwipeActions(for menuItem: MenuItem, at indexPath: IndexPath) -> [SwipeAction] {

            let addAction = SwipeAction(style: .default, title: "Əlavə et") { [weak self] action, _ in
                self?.addItemToBasket(menuItem)
                print("sga isledi")
                action.fulfill(with: .reset)
            }
        addAction.transitionDelegate = ScaleTransition.default
            addAction.backgroundColor = UIColor.systemBlue
            addAction.image = UIImage(systemName: "plus.circle.fill")
            addAction.textColor = .white
            addAction.font = .systemFont(ofSize: 14, weight: .medium)
            
            
            return [addAction]
        }
        
        /// Создает действия для левого свайпа (избранное и другие)
        private func createLeftSwipeActions(for menuItem: MenuItem, at indexPath: IndexPath) -> [SwipeAction] {

            
            let favoriteAction = SwipeAction(style: .default, title: "Seçilmiş") {[weak self] action, _ in
                print("sol isledi")

                action.fulfill(with: .reset)
            }
                
                
                favoriteAction.backgroundColor = .systemRed
                           //            favoriteAction.image = UIImage(systemName: "heart.fill")
            favoriteAction.textColor = .white
            favoriteAction.font = .systemFont(ofSize: 14, weight: .medium)
            
            // Дополнительное действие - поделиться
           
            
            return [favoriteAction]
        }
//    // MARK: Сбрасываем фон ячейки после любого окончания свайпа
//        func collectionView(_ collectionView: UICollectionView,
//                            didEndEditingItemAt indexPath: IndexPath?,
//                            for orientation: SwipeActionsOrientation) {
//            
//            // Если ячейка ещё видна — возвращаем ей белый фон
//            if let ip = indexPath,
//               let cell = collectionView.cellForItem(at: ip) as? SwipeCollectionViewCell {
//                cell.backgroundColor        = .white
//                cell.contentView.backgroundColor = .white
//            }
//        }
    
}
