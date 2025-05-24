//
//  SearchViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//

import Foundation
import UIKit

enum MealCategoryType: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    case dessert = "Dessert" // Учти, что в MealRequestType его пока нет
    case drinks = "Drink"    // Учти, что в MealRequestType его пока нет
    
    var sectionTitle: String {
        return self.rawValue // Можно упростить, если названия совпадают
    }
    
    // НОВОЕ СВОЙСТВО для связи с MealRequestType
    var apiRequestType: MealRequestType? {
        switch self {
        case .breakfast: return .breakfast
        case .lunch: return .lunch
        case .dinner: return .dinner
        case .snack: return .snack
        // Для .dessert и .drinks нужно решить, что делать,
        // так как их нет в твоем текущем MealRequestType.
        // Вариант 1: Вернуть nil, если нет соответствия (и обработать это)
        // Вариант 2: Добавить .dessert и .drinks в MealRequestType
        // Вариант 3: Сопоставить их с существующим типом (например, .snack)
        case .dessert:
             return .snack // Пример: если десерты идут как снэки
            return nil // Пока что nil, нужно определить
        case .drinks:
             return .snack // Пример
            return nil // Пока что nil, нужно определить
        }
    }
}
final class SearchViewModel {
    private let searchUseCase: GetSearchMealUseCase
    
    var onDataChanged: (() -> Void)?
    var onErrorOccurred: ((Error) -> Void)? // Для уведомления UI об ошибках
    
    @MainActor @Published var isLoading: Bool = false // Для индикатора загрузки

    private(set) var mealCategories: [DisplayCategory] = []
    private(set) var filteredSections: [MenuSection] = [] // Это то, что реально отображается
    private(set) var selectedCategoryIndex: Int = 0
    
    private var menuSectionsData: [MenuSection] = [] // Полный набор данных, возможно, с кэшем

    init(searchUseCase: GetSearchMealUseCase = SearchUseCaseImpl()) {
        self.searchUseCase = searchUseCase
        setupInitialData()
    }

    private func setupInitialData() {
        mealCategories = MealCategoryType.allCases.map { DisplayCategory(type: $0) }
        menuSectionsData = MealCategoryType.allCases.map { MenuSection(title: $0.sectionTitle, items: []) }
        filteredSections = menuSectionsData // Изначально отображаем пустые секции

        // Загрузка данных для первой категории при инициализации (опционально)
        if let firstCategory = mealCategories.first?.type {
            Task {
                await fetchAndDisplayMeals(for: firstCategory)
            }
        }
    }

    @MainActor
    func fetchAndDisplayMeals(for categoryType: MealCategoryType) async {
        guard let apiRequestType = categoryType.apiRequestType else {
            print("[SearchViewModel] Нет API-типа для UI-категории: \(categoryType.sectionTitle).")
            // Можно обработать ошибку, например, очистив секцию или показав сообщение
            clearMenuSection(for: categoryType)
            onErrorOccurred?(NSError(domain: "ViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Категория '\(categoryType.sectionTitle)' не поддерживается."]))
            return
        }

        print("[SearchViewModel] Запрос данных для: \(categoryType.sectionTitle) (API: \(apiRequestType.rawValue))")
        if isLoading { return } // Предотвращаем множественные одновременные запросы для одной и той же логики
        isLoading = true
        onDataChanged?() // Показать индикатор

        do {
            let mealResponse = try await searchUseCase.getMealData(for: apiRequestType)
            print("[SearchViewModel] Данные для '\(categoryType.sectionTitle)' получены: \(mealResponse.content.count) элементов.")
            processAndUpdateMenuSection(with: mealResponse.content, for: categoryType)
        } catch {
            print("[SearchViewModel] Ошибка загрузки для '\(categoryType.sectionTitle)': \(error.localizedDescription)")
            clearMenuSection(for: categoryType) // Очищаем секцию при ошибке
            onErrorOccurred?(error)
        }
        isLoading = false
        onDataChanged?() // Скрыть индикатор, обновить данные/ошибку
    }

    @MainActor
    private func processAndUpdateMenuSection(with mealItemsFromAPI: [MealItem], for uiCategoryType: MealCategoryType) {
        let uiMenuItems = mealItemsFromAPI.map { apiItem -> MenuItem in
            let fatDisplay = "\(Int(apiItem.fat.rounded())) g"
            let proteinDisplay = "\(Int(apiItem.protein.rounded())) g"
            let carbsDisplay = "\(Int(apiItem.carbs.rounded())) g"
            
            var quantityDisp: String? = nil
            if apiItem.unitType == .PIECE {
                 // УТОЧНИ, ОТКУДА БРАТЬ КОЛИЧЕСТВО! Сейчас заглушка "1 pc".
                 // Если есть поле, например, `apiItem.servingQuantity`:
                 // quantityDisp = "\(apiItem.servingQuantity ?? 1) pc"
                quantityDisp = "1 pc" // ЗАГЛУШКА
            } else if apiItem.unitType == .GRAM {
                 // Например: quantityDisp = "\(apiItem.servingWeightInGrams ?? 100) g"
            }

            return MenuItem(
                // apiId: apiItem.id,
                name: apiItem.name,
                description: apiItem.description,
                imageName: apiItem.image ?? "", // Пустая строка, если URL нет, Kingfisher обработает
                fatValue: fatDisplay,
                proteinValue: proteinDisplay,
                carbsValue: carbsDisplay,
                quantityInfo: quantityDisp
            )
        }
        
        if let sectionIndex = menuSectionsData.firstIndex(where: { $0.title == uiCategoryType.sectionTitle }) {
            menuSectionsData[sectionIndex].items = uiMenuItems
        } else {
            // Этого не должно происходить, если setupInitialData создает все секции
            print("[SearchViewModel] КРИТИЧЕСКАЯ ОШИБКА: Секция '\(uiCategoryType.sectionTitle)' не найдена в menuSectionsData.")
            // В крайнем случае, можно добавить:
            // menuSectionsData.append(MenuSection(title: uiCategoryType.sectionTitle, items: uiMenuItems))
            // Но это нарушит порядок, если он важен.
        }
        
        // Обновляем filteredSections. Если нет логики фильтрации, то просто присваиваем.
        self.filteredSections = self.menuSectionsData
        // onDataChanged?() вызывается из fetchAndDisplayMeals после isLoading = false
    }
    
    @MainActor
    private func clearMenuSection(for uiCategoryType: MealCategoryType) {
        if let sectionIndex = menuSectionsData.firstIndex(where: { $0.title == uiCategoryType.sectionTitle }) {
            menuSectionsData[sectionIndex].items = []
        }
        self.filteredSections = self.menuSectionsData
        // onDataChanged?() вызывается из fetchAndDisplayMeals
    }
    
    func selectCategory(at index: Int) {
        guard index >= 0, index < mealCategories.count else { return }

        let previouslySelectedCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = index
        
        // Немедленно обновить UI для выделения (если selectedCategoryIndex используется для этого)
        // Если данные для этой категории уже загружены и не пусты, можно не перезагружать.
        // Но для простоты, сейчас перезагружаем всегда.
        onDataChanged?()

        let categoryToFetch = mealCategories[index].type
        Task {
            // Если это не первая загрузка и пользователь кликнул на ту же категорию,
            // можно добавить логику "обновить" или не делать ничего, если данные свежие.
            // Сейчас: всегда загружаем при выборе.
            await fetchAndDisplayMeals(for: categoryToFetch)
        }
    }

    // Методы для UICollectionViewDataSource
    func numberOfSections() -> Int { return 1 + filteredSections.count }
    
    func menuItem(at indexPath: IndexPath) -> MenuItem? {
        guard indexPath.section > 0 else { return nil }
        let menuIndex = indexPath.section - 1
        guard menuIndex >= 0, menuIndex < filteredSections.count else { return nil }
        let sectionItems = filteredSections[menuIndex].items
        guard indexPath.item >= 0, indexPath.item < sectionItems.count else { return nil }
        return sectionItems[indexPath.item]
    }
    
    func numberOfItemsInMenuSection(at sectionIndex: Int) -> Int {
        guard sectionIndex > 0 else { return 0 }
        let menuIndex = sectionIndex - 1
        guard menuIndex >= 0, menuIndex < filteredSections.count else { return 0 }
        return filteredSections[menuIndex].items.count
    }
    
    func menuSection(at sectionIndex: Int) -> MenuSection? {
        guard sectionIndex > 0 else { return nil }
        let menuIndex = sectionIndex - 1
        guard menuIndex >= 0, menuIndex < filteredSections.count else { return nil }
        return filteredSections[menuIndex]
    }
    
    func sectionIndexToScroll(forCategory category: DisplayCategory) -> Int? {
        if let foundIndex = filteredSections.firstIndex(where: { $0.title == category.name }) {
            return foundIndex + 1 // +1, так как первая секция - это категории
        }
        return nil
    }
}

//final class SearchViewModel {
//    private let searchUseCase: GetSearchMealUseCase
//    
//    init(searchUseCase: GetSearchMealUseCase = SearchUseCaseImpl()) {
//        self.searchUseCase = searchUseCase
//        loadData()
//        self.filteredSections = self.menuSectionsData
//    }
//    @MainActor
//    func fetchMeals(for category: MealCategoryType) async throws -> MealListResponse {
//        print("[SearchViewModel] Запрос данных меню для категории: \(category.sectionTitle)")
//        
//        // Получаем соответствующий тип для API запроса
//        guard let apiType = category.apiRequestType else {
//            // Если для этой UI-категории нет соответствующего API-типа,
//            // то либо бросаем ошибку, либо ничего не делаем, либо возвращаем пустой результат.
//            print("[SearchViewModel] Нет API-типа для категории: \(category.sectionTitle). Запрос не будет выполнен.")
//            // Можно бросить кастомную ошибку:
//            // throw NSError(domain: "SearchViewModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Неподдерживаемый тип категории для API: \(category.sectionTitle)"])
//            // Или вернуть "пустой" MealListResponse, если это имеет смысл для твоего UI.
//            // Для примера, просто выйдем (но лучше обработать явно).
//            // В данном случае, чтобы функция скомпилировалась, нужно что-то вернуть или бросить.
//            // Давай для примера бросим ошибку:
//            struct UnsupportedCategoryError: Error, LocalizedError {
//                let categoryName: String
//                var errorDescription: String? { "Категория '\(categoryName)' не поддерживается для запроса к API." }
//            }
//            throw UnsupportedCategoryError(categoryName: category.sectionTitle)
//        }
//        
//        do {
//            // Передаем apiType в UseCase
//            let mealResponse = try await searchUseCase.getMealData(for: apiType) // <--- ИСПРАВЛЕНИЕ ЗДЕСЬ
//            
//            print("[SearchViewModel] Данные меню для '\(category.sectionTitle)' (API тип: \(apiType.rawValue)) получены: \(mealResponse.content.count) элементов.")
//            
//            // Здесь ты будешь обновлять свои UI модели (menuSectionsData, filteredSections)
//            // данными из mealResponse.content (который является [MealItem])
//            updateMenuSection(with: mealResponse.content, for: category)
//            
//            return mealResponse
//        } catch {
//            print("[SearchViewModel] Не удалось загрузить данные меню для '\(category.sectionTitle)' (API тип: \(apiType.rawValue)): \(error.localizedDescription)")
//            throw error
//        }
//    }
//    @MainActor
//    private func updateMenuSection(with mealItemsFromAPI: [MealItem], for uiCategory: MealCategoryType) {
//        // 1. Преобразовать [MealItem] (из API) в [MenuItem] (для UI)
//        let uiMenuItems = mealItemsFromAPI.map { apiItem -> MenuItem in
//            return MenuItem(
//                // id: apiItem.id, // Если ты хочешь использовать ID из API как главный ID
//                name: apiItem.name,
//                description: apiItem.description,
//                price: "...", // Тебе нужно будет определить, как цена приходит из API и как ее форматировать
//                imageName: apiItem.image ?? "placeholder_image_name" // Имя изображения или URL
//            )
//        }
//        
//        // 2. Найти соответствующую секцию в menuSectionsData и обновить ее items
//        if let sectionIndex = menuSectionsData.firstIndex(where: { $0.title == uiCategory.sectionTitle }) {
//            menuSectionsData[sectionIndex].items = uiMenuItems
//            print("[SearchViewModel] Секция '\(uiCategory.sectionTitle)' обновлена \(uiMenuItems.count) элементами.")
//        } else {
//            // Если секция может не существовать и ее нужно создавать динамически
//            // (но у тебя они создаются в loadData, так что этот блок может быть не нужен)
//            print("[SearchViewModel] Внимание: Секция '\(uiCategory.sectionTitle)' не найдена для обновления.")
//            // menuSectionsData.append(MenuSection(title: uiCategory.sectionTitle, items: uiMenuItems))
//        }
//        
//        // 3. Обновить filteredSections (если логика фильтрации есть, иначе просто присвоить)
//        self.filteredSections = self.menuSectionsData
//        
//        // 4. Уведомить ViewController об изменениях
//        self.onDataChanged?()
//    }
//    
//    
//    // MARK: - Public Binding
//    var onDataChanged: (() -> Void)?
//    
//    // MARK: - Data
//    private(set) var mealCategories: [DisplayCategory] = []
//    private(set) var filteredSections: [MenuSection] = []
//    private(set) var selectedCategoryIndex: Int = 0
//    
//    private var menuSectionsData: [MenuSection] = []
//    
//    // Вызывается View Controller при выборе категории
//    //    func selectCategory(at index: Int) {
//    //        // Позволяем повторное "выделение" для прокрутки, если пользователь нажал на уже выбранную категорию
//    //        guard index >= 0, index < mealCategories.count else { return }
//    //        
//    //        selectedCategoryIndex = index
//    //        onDataChanged?()
//    //    }
//    func selectCategory(at index: Int) {
//        guard index >= 0, index < mealCategories.count else { return }
//        
//        selectedCategoryIndex = index
//        let selectedUICategory = mealCategories[index]
//        
//        // Преобразуем DisplayCategory.name обратно в MealCategoryType, чтобы вызвать fetchMeals
//        // Это можно сделать надежнее, если DisplayCategory будет хранить сам MealCategoryType
//        guard let categoryType = MealCategoryType(rawValue: selectedUICategory.name) else {
//            print("[SearchViewModel] Не удалось определить MealCategoryType для \(selectedUICategory.name)")
//            onDataChanged?() // Обновить UI, даже если не удалось загрузить (например, для выделения)
//            return
//        }
//        
//        // Запускаем асинхронную загрузку данных
//        Task {
//            do {
//                print("[SearchViewModel] Выбрана категория: \(categoryType.sectionTitle). Запускаем загрузку данных...")
//                try await fetchMeals(for: categoryType)
//                // onDataChanged?() вызовется внутри updateMenuSection
//            } catch {
//                // Обработка ошибки загрузки (например, показать пользователю сообщение)
//                print("[SearchViewModel] Ошибка при загрузке данных для категории \(categoryType.sectionTitle) при выборе: \(error.localizedDescription)")
//                // Можно здесь вызвать onDataChanged?() чтобы UI обновился, даже если произошла ошибка,
//                // но секция останется пустой или со старыми данными.
//            }
//        }
//        // Если нужно немедленное обновление выделения категории, onDataChanged?() можно вызвать здесь,
//        // но тогда будет два обновления, если загрузка успешна.
//        // Сейчас onDataChanged?() вызывается после обновления данных.
//        // Для мгновенного обновления выделения, можно вызвать onDataChanged?() прямо здесь,
//        // а потом еще раз после загрузки.
//        onDataChanged?() // Для немедленного обновления выделения
//    }
//    
//    func numberOfSections() -> Int {
//        return 1 + filteredSections.count
//    }
//    
//    func menuItem(at indexPath: IndexPath) -> MenuItem? {
//        guard indexPath.section > 0 else { return nil } // Не для секции категорий
//        let menuIndex = indexPath.section - 1
//        guard menuIndex >= 0,
//              menuIndex < filteredSections.count,
//              indexPath.item >= 0,
//              indexPath.item < filteredSections[menuIndex].items.count
//        else {
//            print("Warning: Invalid index path for menuItem: \(indexPath)")
//            return nil
//        }
//        return filteredSections[menuIndex].items[indexPath.item]
//    }
//    
//    // Получение количества элементов в секции меню
//    func numberOfItemsInMenuSection(at sectionIndex: Int) -> Int {
//        guard sectionIndex > 0 else { return 0 } // 0 для секции категорий
//        let menuIndex = sectionIndex - 1
//        guard menuIndex >= 0, menuIndex < filteredSections.count else { return 0 }
//        return filteredSections[menuIndex].items.count
//    }
//    
//    // Получение данных секции (например, для хедера)
//    func menuSection(at sectionIndex: Int) -> MenuSection? {
//        guard sectionIndex > 0 else { return nil }
//        let menuIndex = sectionIndex - 1
//        guard menuIndex >= 0, menuIndex < filteredSections.count else { return nil }
//        return filteredSections[menuIndex]
//    }
//    
//    func sectionIndexToScroll(forCategory category: DisplayCategory) -> Int? {
//        
//        if let foundIndexDirect = filteredSections.firstIndex(where: {
//            $0.title.localizedCaseInsensitiveCompare(category.name) == .orderedSame
//        }) {
//            return foundIndexDirect + 1
//        }
//        
//        print("Warning: Could not find a section to scroll to for category '\(category.name)'")
//        return nil
//    }
//    
//    // MARK: - Private
//    private func loadData() {
//        mealCategories = MealCategoryType.allCases.map { categoryType in
//            DisplayCategory(type: categoryType) // Передаем сам тип
//        }
//        
//        // Инициализируем menuSectionsData для каждой категории
//        menuSectionsData = MealCategoryType.allCases.map { categoryType in
//            MenuSection(title: categoryType.sectionTitle, items: [])
//        }
//        //        mealCategories = [
//        //            DisplayCategory(name: MealCategoryType.breakfast.rawValue, icon: UIImage(named: MealCategoryType.breakfast.rawValue)),
//        //            DisplayCategory(name: MealCategoryType.lunch.rawValue, icon: UIImage(named: MealCategoryType.lunch.rawValue)),
//        //            DisplayCategory(name: MealCategoryType.dinner.rawValue, icon: UIImage(named: MealCategoryType.dinner.rawValue)),
//        //            DisplayCategory(name: MealCategoryType.snack.rawValue, icon: UIImage(named: MealCategoryType.snack.rawValue)),
//        //            DisplayCategory(name: MealCategoryType.dessert.rawValue, icon: UIImage(named: MealCategoryType.dessert.rawValue)),
//        //            DisplayCategory(name: MealCategoryType.drinks.rawValue, icon: UIImage(named: MealCategoryType.drinks.rawValue)),
//        //        ]
//        //        // Полные данные меню (загрузить один раз)
//        //        let mcRoyalBbq = MenuItem( name: "McRoyal Barbekyu", description: "Karamelləşdirilmiş küncütlü bulkanın arasında 100% mal ətind...", price: "₼8,75", imageName: "burger_placeholder_2")
//        //        let dablMcRoyalBbq = MenuItem( name: "Dabl McRoyal Barbekyu", description: "Karamelləşdirilmiş bulkanın arasında iki ədəd 100% mal ətind...", price: "₼12,40", imageName: "burger_placeholder_1")
//        //        let mcRoyalCombo = MenuItem( name:"McRoyal Barbekyu Kombo 2...", description: "2 McRoyal Barbekyu, 2 orta Fri", price: "₼19,50", imageName: "combo_placeholder")
//        //        let bigMac = MenuItem( name: "Big Mac", description: "Классический бургер...", price: "₼6.50", imageName: "burger_placeholder_1")
//        //        let cheeseburger = MenuItem( name: "Cheeseburger", description: "Простой чизбургер...", price: "₼3.00", imageName: "burger_placeholder_2")
//        //        let fries = MenuItem( name: "Orta Kartof Fri", description: "Классический картофель фри", price: "₼2.50", imageName: "combo_placeholder") // Заменить картинку
//        //        let cola = MenuItem( name:"Coca-Cola", description: "Освежающий напиток", price: "₼2.00", imageName: "burger_placeholder_1") // Заменить картинку
//        //        let iceCream = MenuItem( name: "McFlurry", description: "Мороженое с топпингом", price: "₼4.00", imageName: "burger_placeholder_2") // Заменить картинку
//        //        
//        //        // Распределяем по секциям (имитация полной базы данных)
//        //        menuSectionsData = [
//        //            MenuSection(title: "Breakfast", items: [dablMcRoyalBbq, mcRoyalBbq]), // Связь с категорией Yeniliklər
//        //            MenuSection(title: "Lunch", items: [mcRoyalCombo]), // Связь с категорией Təkliflər
//        //            MenuSection(title: "Dinner", items: [bigMac, cheeseburger, mcRoyalBbq, dablMcRoyalBbq]), // Связь с категорией Burgerlər
//        //            MenuSection(title: "Snack", items: [fries]), // Связь с категорией Kartof
//        //            MenuSection(title: "Dessert", items: [cola]), // Связь с категорией İçkilər
//        //            MenuSection(title: "Drinks", items: [iceCream]) // Связь с категорией Desertlər
//        //        ]
//        //    }
//    }
//}
//// MARK: - Модели данных
    struct DisplayCategory: Hashable {
        let id = UUID()
        let type: MealCategoryType // Храним сам тип
        var name: String { type.sectionTitle }
        var icon: UIImage? { UIImage(named: type.rawValue) ?? UIImage(systemName: "circle.fill") }

        init(type: MealCategoryType) {
            self.type = type
        }
    }

// Модель для блюда
    struct MenuItem: Hashable {
        let id = UUID() // Локальный ID для UI
        // var apiId: Int? // Если нужно для каких-то действий (например, добавление в корзину по ID)
        let name: String
        let description: String
        let imageName: String   // URL изображения
        let fatValue: String
        let proteinValue: String
        let carbsValue: String
        let quantityInfo: String?
    }

    struct MenuSection: Hashable {
        let id = UUID()
        let title: String
        var items: [MenuItem]
    }
