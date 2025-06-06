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
    
    private let refreshControl = UIRefreshControl()
    
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
        setupRefreshControl()
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
    private func setupRefreshControl() {
           refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
           
           refreshControl.tintColor = .gray
           
           collectionView.refreshControl = refreshControl
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
            guard let self = self else { return }
            self.collectionView.reloadData()
                       if self.refreshControl.isRefreshing {
                           self.refreshControl.endRefreshing()
                       }
//            viewModel.onMealAddedSuccessfully = { [weak self] in
//                    // Здесь ты можешь показать пользователю алерт об успехе
//                    // Это хорошая практика для UX
//                    let alert = UIAlertController(title: "Успех!", message: "Блюдо добавлено в ваш рацион.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
//                }
//                
//                // Что делать при ошибке
//                viewModel.onMealAddFailed = { [weak self] error in
//                    // Показываем алерт с ошибкой
//                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось добавить блюдо: \(error.localizedDescription)", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
//                }
        }
    }
    @objc private func handleRefresh() {
            Task {
                await viewModel.fetchAllCategoriesSequentiallyAndUpdateAll()
            }
        }
    // --- Actions ---
    @objc private func backButtonTapped() {
        print("salam")
    }
    @objc private func moreButtonTapped() {
        print("More button tapped")
    }
    private func addMealFromUser(_ menuItem: MenuItem) {
        viewModel.addMealToUser(menuItem: menuItem)
    }
    private func deleteMealFromUser(_ menuItem: MenuItem) {
        viewModel.deleteMealFromUser(menuItem: menuItem)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController {
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
                
                let errorMenuItem = MenuItem(
                    serverId: -1,
                    name: "Error",
                    description: "",
                    imageName: "",
                    fatValue: "N/A",
                    proteinValue: "N/A",
                    carbsValue: "N/A",
                    quantityInfo: nil
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
extension SearchViewController {
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
extension SearchViewController {
    
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
        options.transitionStyle = .reveal
        options.buttonSpacing = 10
        options.expansionStyle = .none
        options.expansionDelegate = nil
        
        if orientation == .left {
            options.expansionStyle = SwipeExpansionStyle(
                target: .percentage(0.3),
                additionalTriggers: [
                    .touchThreshold(0.2),
                    .overscroll(3)
                ],
                elasticOverscroll: true,
                completionAnimation: .bounce
            )
            
        } else if orientation == .right {
            options.expansionStyle = SwipeExpansionStyle(
                target: .percentage(0.35),
                additionalTriggers: [
                    .touchThreshold(0.25),
                    .overscroll(3)
                ],
                elasticOverscroll: false,
                completionAnimation: .bounce
            )
        }
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        editActionsForItemAt indexPath: IndexPath,
                        for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard indexPath.section > 0,
              let menuItem = viewModel.menuItem(at: indexPath) else {
            return nil
        }
        
        switch orientation {
        case .left:
            return createLeftSwipeActions(for: menuItem, at: indexPath)
        case .right:
            return createRightSwipeActions(for: menuItem, at: indexPath)
        @unknown default:
            return nil
        }
    }
    
    private func createLeftSwipeActions(for menuItem: MenuItem, at indexPath: IndexPath) -> [SwipeAction] {
        
        let addAction = SwipeAction(style: .default, title: "  Əlavə et") { [weak self] action, _ in
            self?.addMealFromUser(menuItem)
            
            // Добавляем haptic feedback для лучшего UX
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            print("Добавление выполнено")
            action.fulfill(with: .reset)
        }
        
        addAction.transitionDelegate = nil
        addAction.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
        
        // Увеличенная иконка с отступом
        if let plusIcon = UIImage(systemName: "plus.circle.fill") {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold) // Увеличенный размер
            addAction.image = plusIcon.withConfiguration(config)
        }
        
        addAction.textColor = .white
        addAction.font = .systemFont(ofSize: 16, weight: .semibold)
        
        // Отключаем скрытие для плавной анимации
        addAction.hidesWhenSelected = false
        
        return [addAction]
    }
    
    private func createRightSwipeActions(for menuItem: MenuItem, at indexPath: IndexPath) -> [SwipeAction] {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Sil") { [weak self] action, _ in
            self?.deleteMealFromUser(menuItem)
            
            // Добавляем haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            action.fulfill(with: .delete)
        }
        
        // Оптимизация для черного фона - убираем лишние анимации
        deleteAction.transitionDelegate = nil
        
        // Контрастные цвета для черного фона
        deleteAction.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0) // Яркий красный
        deleteAction.textColor = .white // Белый текст для контраста
        deleteAction.font = .systemFont(ofSize: 16, weight: .bold) // Жирный шрифт для лучшей видимости
        
        // Четкая иконка удаления
        if let trashIcon = UIImage(systemName: "trash.fill") {
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
            deleteAction.image = trashIcon.withConfiguration(config)
        }
        deleteAction.hidesWhenSelected = false
        
        return [deleteAction]
    }
}
