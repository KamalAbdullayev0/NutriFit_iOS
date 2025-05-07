//
//  SearchViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 06.05.25.
//
import UIKit


// MARK: - Модели данных
struct DisplayCategory {
    let id = UUID()
    let name: String
}

// Модель для блюда
struct MenuItem { 
    let id = UUID()
    let name: String
    let description: String
    let price: String
    let imageName: String
}

// Модель для секции меню
struct MenuSection { // Убрали Hashable
    let id = UUID()
    let title: String
    var items: [MenuItem]
}
// MARK: - Главный ViewController
class SearchViewController: UIViewController,
                              UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout {

    private let viewModel: SearchViewModel
    private var collectionView: UICollectionView!
    
    private var mealCategories: [DisplayCategory] = []
        private var menuSectionsData: [MenuSection] = []
        private var filteredMenuSectionsData: [MenuSection] = []
        private var selectedMealCategoryIndex = 0

    // --- Инициализатор ---
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // --- Lifecycle & Setup ---
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupCollectionView()
        registerCellsAndHeaders()
        loadData()
        filterMenuDataForSelectedCategory()
        collectionView.reloadData()

    }
    private func setupCollectionView() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical

           collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
           collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Растягиваем по размеру view
           collectionView.backgroundColor = .systemBackground
           collectionView.dataSource = self // Устанавливаем DataSource
           collectionView.delegate = self   // Устанавливаем Delegate
           // collectionView.contentInsetAdjustmentBehavior = .never // Если нужно

           view.addSubview(collectionView) // Добавляем на view контроллера
       }

    // --- Настройка UI ---
    private func setupCustomNavigationBar() {
        navigationItem.hidesBackButton = true // Скроем стандартную кнопку назад
        // Создаем контейнер для кастомных элементов
        let titleViewContainer = UIView()

        // Кнопка назад
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Имитация SearchBar
        let searchBarView = UIView()
        searchBarView.backgroundColor = .tertiarySystemBackground // Цвет фона как у SearchBar
        searchBarView.layer.cornerRadius = 10
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryLabel
        let searchLabel = UILabel()
        searchLabel.text = "McDonald's Inshaatchilar"
        searchLabel.textColor = .secondaryLabel
        searchLabel.font = .systemFont(ofSize: 17)

        // Кнопка "три точки"
        let moreButton = UIButton(type: .system)
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .label
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)

        // Добавляем элементы и настраиваем AutoLayout
        [backButton, searchBarView, moreButton, searchIcon, searchLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        searchBarView.addSubview(searchIcon)
        searchBarView.addSubview(searchLabel)
        titleViewContainer.addSubview(backButton)
        titleViewContainer.addSubview(searchBarView)
        titleViewContainer.addSubview(moreButton)

        NSLayoutConstraint.activate([
            // Кнопка назад
            backButton.leadingAnchor.constraint(equalTo: titleViewContainer.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: titleViewContainer.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            // Имитация SearchBar
            searchBarView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            searchBarView.centerYAnchor.constraint(equalTo: titleViewContainer.centerYAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 36), // Стандартная высота SearchBar

            // Кнопка "еще"
            moreButton.leadingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: 8),
            moreButton.trailingAnchor.constraint(equalTo: titleViewContainer.trailingAnchor),
            moreButton.centerYAnchor.constraint(equalTo: titleViewContainer.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.heightAnchor.constraint(equalToConstant: 40),

            // Элементы внутри SearchBar
            searchIcon.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 8),
            searchIcon.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchLabel.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -8),
            searchLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor)
        ])

        navigationItem.titleView = titleViewContainer
    }

    private func registerCellsAndHeaders() {
            collectionView.register(CategoryContainerCell.self, forCellWithReuseIdentifier: CategoryContainerCell.reuseIdentifier)
            // --- ИСПРАВЛЕНО: Регистрируем MenuItemCell ---
            collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
            // --- КОНЕЦ ИСПРАВЛЕНИЯ ---
            collectionView.register(MenuSectionHeaderView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: MenuSectionHeaderView.reuseIdentifier)
            // Регистрация fallback header (можно убрать, если уверены в логике viewForSupplementaryElementOfKind)
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emptyHeaderFallback")
        }

    // --- Загрузка данных (Mock) ---
    private func loadData() {
        // Категории приемов пищи
        mealCategories = [
            DisplayCategory(name: "Yeniliklər"), // Новинки (как на скриншоте)
            DisplayCategory(name: "Təkliflər"),  // Предложения
            DisplayCategory(name: "Burgerlər"), // Бургеры
            DisplayCategory(name: "Kartof"),    // Картофель
            DisplayCategory(name: "İçkilər"),   // Напитки
            DisplayCategory(name: "Desertlər")  // Десерты
        ]

        // Полные данные меню (загрузить один раз)
        let mcRoyalBbq = MenuItem( name: "McRoyal Barbekyu", description: "Karamelləşdirilmiş küncütlü bulkanın arasında 100% mal ətind...", price: "₼8,75", imageName: "burger_placeholder_2")
        let dablMcRoyalBbq = MenuItem( name: "Dabl McRoyal Barbekyu", description: "Karamelləşdirilmiş bulkanın arasında iki ədəd 100% mal ətind...", price: "₼12,40", imageName: "burger_placeholder_1")
        let mcRoyalCombo = MenuItem( name:"McRoyal Barbekyu Kombo 2...", description: "2 McRoyal Barbekyu, 2 orta Fri", price: "₼19,50", imageName: "combo_placeholder")
        let bigMac = MenuItem( name: "Big Mac", description: "Классический бургер...", price: "₼6.50", imageName: "burger_placeholder_1")
        let cheeseburger = MenuItem( name: "Cheeseburger", description: "Простой чизбургер...", price: "₼3.00", imageName: "burger_placeholder_2")
        let fries = MenuItem( name: "Orta Kartof Fri", description: "Классический картофель фри", price: "₼2.50", imageName: "combo_placeholder") // Заменить картинку
        let cola = MenuItem( name:"Coca-Cola", description: "Освежающий напиток", price: "₼2.00", imageName: "burger_placeholder_1") // Заменить картинку
        let iceCream = MenuItem( name: "McFlurry", description: "Мороженое с топпингом", price: "₼4.00", imageName: "burger_placeholder_2") // Заменить картинку


        // Распределяем по секциям (имитация полной базы данных)
        menuSectionsData = [
            MenuSection(title: "Yeniliklər", items: [dablMcRoyalBbq, mcRoyalBbq]), // Связь с категорией Yeniliklər
            MenuSection(title: "Təkliflər", items: [mcRoyalCombo]), // Связь с категорией Təkliflər
            MenuSection(title: "Burgerlər", items: [bigMac, cheeseburger, mcRoyalBbq, dablMcRoyalBbq]), // Связь с категорией Burgerlər
            MenuSection(title: "Kartof", items: [fries]), // Связь с категорией Kartof
            MenuSection(title: "İçkilər", items: [cola]), // Связь с категорией İçkilər
            MenuSection(title: "Desertlər", items: [iceCream]) // Связь с категорией Desertlər
        ]
    }

    // --- Фильтрация данных ---
    private func filterMenuDataForSelectedCategory() {
        guard selectedMealCategoryIndex < mealCategories.count else {
            filteredMenuSectionsData = [] // Если индекс неверный, показываем пустое меню
            return
        }
        let selectedCategory = mealCategories[selectedMealCategoryIndex]

        // Фильтруем ПОЛНЫЙ список menuSectionsData
        // Логика фильтрации зависит от того, как связаны категории и секции.
        // Пример: если название категории совпадает с названием секции.
        filteredMenuSectionsData = menuSectionsData.filter { section in
            section.title.localizedCaseInsensitiveCompare(selectedCategory.name) == .orderedSame
        }
        // Если нет совпадений, можно показать все или специальную секцию
        if filteredMenuSectionsData.isEmpty && !menuSectionsData.isEmpty {
             print("Для категории '\(selectedCategory.name)' нет явных секций, показываем первую секцию данных.")
             // filteredMenuSectionsData = [menuSectionsData[0]] // Показать первую секцию как fallback
             filteredMenuSectionsData = menuSectionsData // Или показать всё меню? Зависит от ТЗ. Пока покажем всё.
        }

        print("Отфильтровано \(filteredMenuSectionsData.count) секций для категории '\(selectedCategory.name)'")
    }


    

    // --- Обработка выбора категории ---
    private func didSelectMealCategory(_ category: DisplayCategory, at index: Int) {
            guard selectedMealCategoryIndex != index else { return }
            print("Выбрана категория: \(category.name) at index \(index)")
            selectedMealCategoryIndex = index
            filterMenuDataForSelectedCategory()
            // Вместо applySnapshot используем reloadData
            collectionView.reloadData() // <--- ВАЖНО: Обновление UI
        }

    // --- Actions ---
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func moreButtonTapped() {
        print("More button tapped")
    }
    private func addItemToBasket(_ menuItem: MenuItem) {
        print("Добавление в корзину: \(menuItem.name)")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1 + filteredMenuSectionsData.count // 1 секция для категорий + отфильтрованные меню
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if section == 0 {
                return 1 // Всегда одна ячейка-контейнер в первой секции
            } else {
                let menuIndex = section - 1
                // Проверяем границы массива отфильтрованных данных
                guard menuIndex >= 0 && menuIndex < filteredMenuSectionsData.count else { return 0 }
                return filteredMenuSectionsData[menuIndex].items.count
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.section == 0 {
                // --- Секция Категорий ---
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryContainerCell.reuseIdentifier, for: indexPath) as? CategoryContainerCell else {
                    fatalError("Cannot create CategoryContainerCell")
                }
                cell.configure(with: mealCategories, selectedIndex: selectedMealCategoryIndex)
                cell.onCategorySelected = { [weak self] (category, index) in
                    self?.didSelectMealCategory(category, at: index)
                }
                return cell
            } else {
                // --- Секции Меню ---
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell else {
                    fatalError("Cannot create MenuItemCell")
                }
                let menuIndex = indexPath.section - 1
                // Проверяем границы перед доступом к данным
                guard menuIndex >= 0 && menuIndex < filteredMenuSectionsData.count,
                      indexPath.item < filteredMenuSectionsData[menuIndex].items.count else {
                     // В идеале этого не должно происходить, если numberOfItemsInSection работает правильно
                     print("Error: Data inconsistency in cellForItemAt for menu section.")
                     // Можно вернуть пустую сконфигурированную ячейку
                     cell.configure(with: MenuItem(name: "Error", description: "", price: "", imageName: ""))
                     return cell
                }
                let menuItem = filteredMenuSectionsData[menuIndex].items[indexPath.item]
                cell.configure(with: menuItem)
                return cell
            }
        }

        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard kind == UICollectionView.elementKindSectionHeader else {
                // Если нужен другой kind (footer), обработать здесь
                fatalError("Unexpected supplementary view kind: \(kind)")
            }

            // Хедер нужен только для секций меню (section > 0)
            guard indexPath.section > 0 else {
                // Для секции 0 возвращаем пустой базовый view (его размер будет 0 по FlowLayout delegate)
                // Но лучше зарегистрировать пустой идентификатор для этого случая
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyHeaderFallback", for: indexPath) // Регистрируем "emptyHeaderFallback", если еще не сделано
            }

            guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MenuSectionHeaderView.reuseIdentifier,
                    for: indexPath) as? MenuSectionHeaderView else {
                fatalError("Failed to dequeue MenuSectionHeaderView")
            }

            let menuIndex = indexPath.section - 1
            // Проверяем границы и пустоту секции
            guard menuIndex >= 0 && menuIndex < filteredMenuSectionsData.count,
                  !filteredMenuSectionsData[menuIndex].items.isEmpty else {
                // Возвращаем сконфигурированный, но пустой хедер (размер будет 0 по делегату)
                header.configure(title: "", showTranslate: false)
                return header
            }

            let sectionData = filteredMenuSectionsData[menuIndex]
            let showTranslate = (indexPath.section == 1) // Пример логики
            header.configure(title: sectionData.title, showTranslate: showTranslate)
            header.translateAction = { [weak self] in
                print("Нажата кнопка Translate для секции: \(sectionData.title)")
            }
            return header
        }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController /* : UICollectionViewDelegateFlowLayout */ {
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let availableWidth = collectionView.bounds.width - sectionInsets.left - sectionInsets.right

        if indexPath.section == 0 {
            // Ячейка-контейнер категорий
            return CGSize(width: collectionView.bounds.width, height: 55) // Полная ширина
        } else {
            // Ячейка блюда
            return CGSize(width: availableWidth, height: 110)
        }
    }

    // Размер хедера секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero // Нет хедера для категорий
        } else {
            // Проверяем, пуста ли отфильтрованная секция
            let menuIndex = section - 1
            guard menuIndex >= 0 && menuIndex < filteredMenuSectionsData.count,
                  !filteredMenuSectionsData[menuIndex].items.isEmpty else {
                return .zero // Нет хедера для пустой секции
            }
            // Стандартный размер хедера
            let availableWidth = collectionView.bounds.width - 32
            return CGSize(width: availableWidth, height: 44)
        }
    }

    // Отступы для секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
             let topPadding: CGFloat
             if let navBarHeight = navigationController?.navigationBar.frame.height {
                 // Используем view.safeAreaInsets.top для учета статус бара и "челки"
                 topPadding = navBarHeight + view.safeAreaInsets.top + 10
             } else {
                 // Fallback, если navigationController или navigationBar недоступны
                 topPadding = view.safeAreaInsets.top + 54 // Приблизительно 44 + 10
             }
             return UIEdgeInsets(top: topPadding, left: 0, bottom: 10, right: 0)
        } else {
            // Отступы для секций меню
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
    }

    // Минимальное вертикальное расстояние между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
}

// MARK: - UICollectionViewDelegate (Swipe Actions & Selection)
extension SearchViewController /* : UICollectionViewDelegate */ {

    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Свайп только для секций меню
        guard indexPath.section > 0 else { return nil }

        let menuIndex = indexPath.section - 1
        guard menuIndex >= 0 && menuIndex < filteredMenuSectionsData.count,
              indexPath.item < filteredMenuSectionsData[menuIndex].items.count else { return nil }

        let menuItem = filteredMenuSectionsData[menuIndex].items[indexPath.item]

        let addAction = UIContextualAction(style: .normal, title: "Əlavə et") { [weak self] (_, _, completion) in
           self?.addItemToBasket(menuItem)
           completion(true)
        }
        addAction.backgroundColor = .systemGreen
        addAction.image = UIImage(systemName: "plus.circle.fill")
        return UISwipeActionsConfiguration(actions: [addAction])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        // Обрабатываем нажатие только на ячейки меню
        guard indexPath.section > 0 else { return }

        let menuIndex = indexPath.section - 1
        guard menuIndex >= 0 && menuIndex < filteredMenuSectionsData.count,
              indexPath.item < filteredMenuSectionsData[menuIndex].items.count else { return }

        let menuItem = filteredMenuSectionsData[menuIndex].items[indexPath.item]
        print("Нажата ячейка блюда: \(menuItem.name)")
        // Открыть детальный экран...
    }

     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         // Не подсвечивать ячейку-контейнер
         return indexPath.section != 0
     }
}
