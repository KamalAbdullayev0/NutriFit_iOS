//
//  DietViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
// DietViewController.swift

import UIKit

class DietViewController: UIViewController {
    private lazy var macroSummaryView = MacroSummaryView()
    private lazy var macroIndicatorView = MacroIndicatorView()
    
    private var categories: [CategoryEntity] = [
        CategoryEntity(categoryId: "1", categoryName: "Завтрак", categoryEmoji: "🍳"),
        CategoryEntity(categoryId: "2", categoryName: "Обед", categoryEmoji: "🍲"),
        CategoryEntity(categoryId: "3", categoryName: "Ужин", categoryEmoji: "🥗"),
        CategoryEntity(categoryId: "4", categoryName: "Перекус", categoryEmoji: "🍎"),
        CategoryEntity(categoryId: "5", categoryName: "Десерт", categoryEmoji: "🍰"),
        CategoryEntity(categoryId: "6", categoryName: "Напитки", categoryEmoji: "🍹")
    ]
    private var days: [DayData] = []
    private var selectedDayIndexPath: IndexPath?
    
    private lazy var collectionViewDays: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 70)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(DetailedDayCell.self, forCellWithReuseIdentifier: DetailedDayCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
        return cv
    }()
    
    private lazy var collectionViewCategories: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Питание"
        view.backgroundColor = .systemGray6
        setupViews()
        setupConstraints()
        generateWeekDays()
        selectTodayInitially()
    }
    
    private func setupViews() {
        macroSummaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(macroSummaryView)
        macroIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(macroIndicatorView)
        
        view.addSubview(collectionViewDays)
        view.addSubview(collectionViewCategories)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            collectionViewDays.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionViewDays.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewDays.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewDays.heightAnchor.constraint(equalToConstant: 70),
            
            macroIndicatorView.topAnchor.constraint(equalTo: collectionViewDays.bottomAnchor, constant: 30),
            macroIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            macroSummaryView.topAnchor.constraint(equalTo: macroIndicatorView.bottomAnchor, constant: 25),
            macroSummaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            macroSummaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            macroSummaryView.heightAnchor.constraint(equalToConstant: 70),
            
            collectionViewCategories.topAnchor.constraint(equalTo: macroSummaryView.bottomAnchor, constant: 30),
            collectionViewCategories.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewCategories.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewCategories.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    private func generateWeekDays() {
        days.removeAll()
        let calendar = Calendar.current
        let todayReference = Date()
        let startGenerationDate = todayReference - 4 * 24 * 60 * 60
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = "EE"
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: startGenerationDate) else { return }
        var currentDay = weekInterval.start
        
        for _ in 0..<14 {
            if let day = calendar.date(byAdding: .day, value: 0, to: currentDay) {
                let dayName = dateFormatter.string(from: day).capitalized
                let isToday = calendar.isDate(day, inSameDayAs: todayReference)
                days.append(DayData(name: dayName, date: day, isToday: isToday))
                currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? Date()
            }
        }
        collectionViewDays.reloadData()
    }
    
    private func selectTodayInitially() {
        // ... (код выбора дня остается без изменений) ...
        if let todayIndex = days.firstIndex(where: { $0.isToday }) {
            let indexPath = IndexPath(item: todayIndex, section: 0)
            selectedDayIndexPath = indexPath
            collectionViewDays.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        } else if !days.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            selectedDayIndexPath = indexPath
            collectionViewDays.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        // Загружаем данные для первоначально выбранного дня
        if let selectedPath = selectedDayIndexPath {
            let selectedDay = days[selectedPath.item]
            handleDaySelection(date: selectedDay.date)
        }
    }
    
    private func loadAndDisplayNutritionData() {
        print("Загрузка данных о питании...")
        let currentKcal = Int.random(in: 1500...2500)
        let totalKcal = 2922
        let carbs = Int.random(in: 150...300)
        let protein = Int.random(in: 50...120)
        let fat = Int.random(in: 40...90)
        
        macroIndicatorView.update(currentKcal: currentKcal, totalKcal: totalKcal)
        macroSummaryView.update(carbs: carbs, protein: protein, fat: fat)
    }
    
    
    private func handleDaySelection(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        print("Выбран день: \(formatter.string(from: date))")
        loadAndDisplayNutritionData()
    }
    
    private func fetchKetoMeals(categoryName: String) {
        print("Загрузка кето-блюд для категории: \(categoryName)...")
    }
    
    private func animateTap(on view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            view.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
                view.alpha = 1.0
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DietViewController: UICollectionViewDataSource {
    // ... (код DataSource остается без изменений) ...
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewDays {
            return days.count
        } else if collectionView == collectionViewCategories {
            return categories.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDays {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedDayCell.identifier, for: indexPath) as? DetailedDayCell else {
                fatalError("Unable to dequeue DetailedDayCell")
            }
            let day = days[indexPath.item]
            cell.configure(with: day)
            cell.isSelected = (indexPath == selectedDayIndexPath)
            return cell
            
        } else if collectionView == collectionViewCategories {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                assertionFailure("Не удалось декьюить CategoryCell")
                return UICollectionViewCell()
            }
            let category = categories[indexPath.item]
            cell.configure(with: category)
            return cell
            
        } else {
            assertionFailure("Unknown collection view requesting cell")
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension DietViewController: UICollectionViewDelegate {
    // ... (код Delegate остается без изменений) ...
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewDays {
            // --- Логика выбора дня ---
            if indexPath == selectedDayIndexPath { return }
            
            let previouslySelectedIndexPath = selectedDayIndexPath
            selectedDayIndexPath = indexPath
            
            var indexPathsToReload: [IndexPath] = []
            if let previous = previouslySelectedIndexPath { indexPathsToReload.append(previous) }
            indexPathsToReload.append(indexPath)
            
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: indexPathsToReload)
            }) { _ in
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            let selectedDay = days[indexPath.item]
            handleDaySelection(date: selectedDay.date)
            
        } else if collectionView == collectionViewCategories {
            let selectedCategory = categories[indexPath.item]
            print("Выбрана категория: \(selectedCategory.categoryName) (ID: \(selectedCategory.categoryId))")
            fetchKetoMeals(categoryName: selectedCategory.categoryName)
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                animateTap(on: cell)
            }
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == collectionViewDays {
            return indexPath != selectedDayIndexPath
        }
        return true
    }
}
#Preview {
    DietViewController()
}
