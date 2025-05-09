//
//  SearchViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//

import Foundation

final class SearchViewModel {
    private let searchUseCase: SearchUseCaseImpl
    
    init(searchUseCase: SearchUseCaseImpl) {
        self.searchUseCase = searchUseCase
        loadData()
        filterData()
    }
    // MARK: - Public Binding
    var onDataChanged: (() -> Void)?
    
    // MARK: - Data
    private(set) var mealCategories: [DisplayCategory] = []
    private(set) var filteredSections: [MenuSection] = []
    private(set) var selectedCategoryIndex: Int = 0
    
    private var menuSectionsData: [MenuSection] = []
    
    // Вызывается View Controller при выборе категории
    func selectCategory(at index: Int) {
        guard index >= 0, index < mealCategories.count, index != selectedCategoryIndex else { return }
        
        selectedCategoryIndex = index
        filterData() // Фильтруем данные
        onDataChanged?() // Уведомляем ViewController об изменениях
    }
    
    func numberOfSections() -> Int {
        return 1 + filteredSections.count
    }
    
    func menuItem(at indexPath: IndexPath) -> MenuItem? {
        guard indexPath.section > 0 else { return nil } // Не для секции категорий
        let menuIndex = indexPath.section - 1
        guard menuIndex >= 0,
              menuIndex < filteredSections.count,
              indexPath.item >= 0,
              indexPath.item < filteredSections[menuIndex].items.count
        else {
            print("Warning: Invalid index path for menuItem: \(indexPath)")
            return nil
        }
        return filteredSections[menuIndex].items[indexPath.item]
    }
    
    // Получение количества элементов в секции меню
    func numberOfItemsInMenuSection(at sectionIndex: Int) -> Int {
        guard sectionIndex > 0 else { return 0 } // 0 для секции категорий
        let menuIndex = sectionIndex - 1
        guard menuIndex >= 0, menuIndex < filteredSections.count else { return 0 }
        return filteredSections[menuIndex].items.count
    }
    
    // Получение данных секции (например, для хедера)
    func menuSection(at sectionIndex: Int) -> MenuSection? {
        guard sectionIndex > 0 else { return nil }
        let menuIndex = sectionIndex - 1
        guard menuIndex >= 0, menuIndex < filteredSections.count else { return nil }
        return filteredSections[menuIndex]
    }
    
    
    private func filterData() {
        guard selectedCategoryIndex < mealCategories.count else {
            filteredSections = menuSectionsData
            print("Warning: selectedCategoryIndex out of bounds, showing all sections.")
            return
        }
        let selectedCategory = mealCategories[selectedCategoryIndex]
        filteredSections = menuSectionsData.filter { $0.title.localizedCaseInsensitiveCompare(selectedCategory.name) == .orderedSame }
        
        if filteredSections.isEmpty && !menuSectionsData.isEmpty {
            print("Для категории '\(selectedCategory.name)' нет явных секций, показываем все меню.")
            filteredSections = menuSectionsData // Fallback - показать все
        }
        print("[ViewModel] Отфильтровано \(filteredSections.count) секций для категории '\(selectedCategory.name)'")
    }
    // MARK: - Private
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
}
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

struct MenuSection {
    let id = UUID()
    let title: String
    var items: [MenuItem]
}
