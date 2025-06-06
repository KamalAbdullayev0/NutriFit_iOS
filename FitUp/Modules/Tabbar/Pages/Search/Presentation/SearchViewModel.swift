//
//  SearchViewModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 05.05.25.
//
import Foundation

final class SearchViewModel {
    private let searchUseCase: GetSearchMealUseCase
    private let addUserMealUseCase: AddUserMealUseCaseProtocol
    
    var onDataChanged: (() -> Void)?
    var onErrorOccurred: ((Error) -> Void)?
    
    var onMealAddedSuccessfully: (() -> Void)?
    var onMealAddFailed: ((Error) -> Void)?
    
    @MainActor private(set) var isLoading: Bool = false
    
    private(set) var mealCategories: [DisplayCategory] = []
    
    private(set) var filteredSections: [MenuSection] = []
    private(set) var selectedCategoryIndex: Int = 0
    
    private var menuSectionsData: [MenuSection] = []
    
    init(searchUseCase: GetSearchMealUseCase = SearchUseCaseImpl(),
             addUserMealUseCase: AddUserMealUseCaseProtocol = AddUserMealUseCase()) { // Используем реализацию по умолчанию
            self.searchUseCase = searchUseCase
            self.addUserMealUseCase = addUserMealUseCase // Сохраняем зависимость
            setupInitialDataAndLoadAll()
        }
    
    private func setupInitialDataAndLoadAll() {
        mealCategories = MealType.allCases.map { DisplayCategory(mealType: $0) }
        menuSectionsData = MealType.allCases.map { MenuSection(title: $0.displayName, items: []) }
        filteredSections = menuSectionsData
        
        Task {
            await fetchAllCategoriesSequentiallyAndUpdateAll()
        }
    }
    @MainActor
        func addMealToUserBasket(menuItem: MenuItem) {
            Task {
                do {
                    let userMealEntry = try await addUserMealUseCase.execute(
                        mealId: menuItem.serverId,
                        quantity: 1.0
                    )
                    
                    print("[SearchViewModel] Блюдо '\(menuItem.name)' успешно добавлено. ID записи: \(userMealEntry.id)")
                    
                    onMealAddedSuccessfully?()
                    
                } catch {
                    print("[SearchViewModel] Ошибка при добавлении блюда '\(menuItem.name)': \(error)")
                    
                    // Уведомляем UI об ошибке
                    onMealAddFailed?(error)
                }
            }
        }
    
    @MainActor
    func fetchAllCategoriesSequentiallyAndUpdateAll() async {
        isLoading = true
        onDataChanged?()
        
        var accumulatedErrors: [Error] = []
        
        for (index, MealType) in MealType.allCases.enumerated() {
            
            do {
                let mealResponse = try await searchUseCase.getMealData(for: MealType)
                let uiMenuItems = mealResponse.content.map { apiItem -> MenuItem in
                    let fatDisplay = "\(Int(apiItem.fat.rounded())) g"
                    let proteinDisplay = "\(Int(apiItem.protein.rounded())) g"
                    let carbsDisplay = "\(Int(apiItem.carbs.rounded())) g"
                    var quantityDisp: String? = nil
                    if apiItem.unitType == .PIECE { quantityDisp = "1 pc"}
                    
                    return MenuItem(serverId: apiItem.id,name: apiItem.name, description: apiItem.description, imageName: apiItem.image ?? "", fatValue: fatDisplay, proteinValue: proteinDisplay, carbsValue: carbsDisplay, quantityInfo: quantityDisp)
                }
                
                if index < menuSectionsData.count {
                    menuSectionsData[index].items = uiMenuItems
                }
                
            } catch {
                menuSectionsData[index].items = []
                accumulatedErrors.append(error)
            }
        }
        
        self.filteredSections = self.menuSectionsData
        isLoading = false
        onDataChanged?()
        if !accumulatedErrors.isEmpty {
            onErrorOccurred?(accumulatedErrors.first!)
        }
    }
    
    @MainActor
    private func updateDisplayedSections() {
        let selectedMealType = mealCategories[selectedCategoryIndex].mealType
        if let sectionToShow = menuSectionsData.first(where: { $0.title == selectedMealType.displayName }) {
            filteredSections = [sectionToShow]
        } else {
            filteredSections = []
            print("[SearchViewModel] Ошибка: не найдена секция для \(selectedMealType.displayName)")
        }
        onDataChanged?()
    }
    
    @MainActor func selectCategory(at index: Int) {
        guard index >= 0, index < mealCategories.count else { return }
        if selectedCategoryIndex == index && filteredSections.count == 1 && filteredSections.first?.title == mealCategories[index].name {
            onDataChanged?()
            return
        }
        
        selectedCategoryIndex = index
        updateDisplayedSections()
    }
    
    func numberOfSections() -> Int {
        return 1 + filteredSections.count
    }
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
}
