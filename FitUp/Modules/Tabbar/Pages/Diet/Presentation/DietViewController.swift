//
//  DietViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

class DietViewController: UIViewController {

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
    
    private lazy var daysView: DaysHorizontalView = {
        let view = DaysHorizontalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var categoriesView: CategoriesHorizontalView = {
        let view = CategoriesHorizontalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var macroSummaryView = MacroSummaryView()
    private lazy var macroIndicatorView = MacroIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupViews()
        setupConstraints()
        setupGradientBackground()
        generateWeekDays()
        configureComponents()
    }

     func setupGradientBackground() {
         let gradientLayer = CAGradientLayer()
         gradientLayer.frame = view.bounds
         gradientLayer.colors = [
             UIColor(red: 0.9, green: 0.9, blue: 0.85, alpha: 1.0).cgColor,
             UIColor.white.cgColor
         ]
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
         gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
         
         view.layer.insertSublayer(gradientLayer, at: 0)
     }

     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
             gradientLayer.frame = view.bounds
         }
     }

    private func setupViews() {
        view.addSubview(daysView)
        macroSummaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(macroSummaryView)
        macroIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(macroIndicatorView)
        view.addSubview(categoriesView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            daysView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            daysView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            daysView.heightAnchor.constraint(equalToConstant: 70), // Высота компонента

            macroIndicatorView.topAnchor.constraint(equalTo: daysView.bottomAnchor, constant: 30),
            macroIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            macroSummaryView.topAnchor.constraint(equalTo: macroIndicatorView.bottomAnchor, constant: 25),
            macroSummaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            macroSummaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            macroSummaryView.heightAnchor.constraint(equalToConstant: 70),
            
            categoriesView.topAnchor.constraint(equalTo: macroSummaryView.bottomAnchor, constant: 30),
            categoriesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func generateWeekDays() {
        days.removeAll()
        let calendar = Calendar.current
        let todayReference = Date()
        let daysBeforeToday = 7 // Количество дней до "сегодня"
        guard let startGenerationDate = calendar.date(byAdding: .day, value: -daysBeforeToday, to: todayReference) else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = "EE"

        let totalDaysToGenerate = 14
        var currentDayIterator = startGenerationDate

        for i in 0..<totalDaysToGenerate {
            let dayName = dateFormatter.string(from: currentDayIterator).capitalized
            let isToday = calendar.isDate(currentDayIterator, inSameDayAs: todayReference)
            let dayNumber = calendar.component(.day, from: currentDayIterator)
            let dayData = DayData(name: dayName, date: currentDayIterator, isToday: isToday)
            days.append(dayData)

            if isToday {
                selectedDayIndexPath = IndexPath(item: i, section: 0)
            }

            currentDayIterator = calendar.date(byAdding: .day, value: 1, to: currentDayIterator) ?? Date()
        }

        if selectedDayIndexPath == nil && !days.isEmpty {
            selectedDayIndexPath = IndexPath(item: 0, section: 0)
        }
    }

    private func configureComponents() {
        daysView.configure(with: days, selectedIndexPath: selectedDayIndexPath)
        categoriesView.configure(with: categories)

        if let initialIndexPath = selectedDayIndexPath {
            let initialSelectedDate = days[initialIndexPath.item].date
            handleDaySelection(date: initialSelectedDate)
        } else {
            print("Начальный день не выбран или массив дней пуст.")
             macroIndicatorView.update(currentKcal: 0, totalKcal: 2922)
             macroSummaryView.update(carbs: 0, protein: 0, fat: 0)
        }
    }

    private func handleDaySelection(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        print("Выбран день (из VC): \(formatter.string(from: date))")
        loadAndDisplayNutritionData(for: date)
    }

    private func fetchKetoMeals(categoryName: String) {
        print("Загрузка кето-блюд для категории (из VC): \(categoryName)...")
    }

    private func loadAndDisplayNutritionData(for date: Date) {
        print("Загрузка данных о питании для даты: \(date)...")
        let currentKcal = Int.random(in: 1500...2500)
        let totalKcal = 2922
        let carbs = Int.random(in: 150...300)
        let protein = Int.random(in: 50...120)
        let fat = Int.random(in: 40...90)

        macroIndicatorView.update(currentKcal: currentKcal, totalKcal: totalKcal)
        macroSummaryView.update(carbs: carbs, protein: protein, fat: fat)
    }
}

extension DietViewController: DaysHorizontalViewDelegate {
    func daysHorizontalView(_ view: DaysHorizontalView, didSelectDay date: Date, at indexPath: IndexPath) {
        self.selectedDayIndexPath = indexPath
        handleDaySelection(date: date)
    }
}

extension DietViewController: CategoriesHorizontalViewDelegate {
    func categoriesHorizontalView(_ view: CategoriesHorizontalView, didSelectCategory category: CategoryEntity) {
        print("Выбрана категория (из VC): \(category.categoryName) (ID: \(category.categoryId))")
        fetchKetoMeals(categoryName: category.categoryName)
    }
}
