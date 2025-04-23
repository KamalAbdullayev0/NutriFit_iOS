//
//  DietViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

class MealViewController: UIViewController {
    private let viewModel: MealViewModel
    
    private var categories: [CategoryEntity] = [
        CategoryEntity(categoryId: "1", categoryName: "Breakfast", categoryEmoji: "🍳"),
        CategoryEntity(categoryId: "2", categoryName: "Lunch", categoryEmoji: "🍲"),
        CategoryEntity(categoryId: "3", categoryName: "Dinner", categoryEmoji: "🥗"),
        CategoryEntity(categoryId: "4", categoryName: "Snack", categoryEmoji: "🍎"),
        CategoryEntity(categoryId: "5", categoryName: "Dessert", categoryEmoji: "🍰"),
        CategoryEntity(categoryId: "6", categoryName: "Drinks", categoryEmoji: "🍹")
    ]
    private var days: [DayData] = []
    private var selectedDayIndexPath: IndexPath?

    // --- UI Элементы ---
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

    private var currentDataTask: Task<Void, Never>?

    // MARK: - Initialization
    init(viewModel: MealViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
//        setupGradientBackground()
        generateWeekDays()
        configureViewsInitially()
        loadInitialData()
//        view.backgroundColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

    // MARK: - UI Setup
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
            daysView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            daysView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            daysView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            daysView.heightAnchor.constraint(equalToConstant: 100),

            macroIndicatorView.topAnchor.constraint(equalTo: daysView.bottomAnchor, constant: 20),
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

    // MARK: - Data Generation & Initial Configuration
    private func generateWeekDays() {
        days.removeAll()
        let calendar = Calendar.current
        let todayReference = Date()
        let daysBeforeToday = 7
        guard let startGenerationDate = calendar.date(byAdding: .day, value: -daysBeforeToday, to: todayReference) else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EE"

        let dayNumberFormatter = DateFormatter()
           dayNumberFormatter.dateFormat = "d"
        
        let totalDaysToGenerate = 14
        var currentDayIterator = startGenerationDate
        
        for i in 0..<totalDaysToGenerate {
            let dayName = dateFormatter.string(from: currentDayIterator).capitalized
            let dayNumberStr = dayNumberFormatter.string(from: currentDayIterator)
            let isToday = calendar.isDate(currentDayIterator, inSameDayAs: todayReference)
            
            let dayData = DayData(name: dayName,
                                  date: currentDayIterator,
                                  isToday: isToday,
                                  dayNumberString: dayNumberStr)
            days.append(dayData)

            if isToday {
                selectedDayIndexPath = IndexPath(item: i, section: 0)
            }
            currentDayIterator = calendar.date(byAdding: .day, value: 1, to: currentDayIterator)!
        }

        if selectedDayIndexPath == nil && !days.isEmpty {
            selectedDayIndexPath = IndexPath(item: daysBeforeToday, section: 0)
            if selectedDayIndexPath!.item >= days.count {
                 selectedDayIndexPath = IndexPath(item: 0, section: 0)
            }
        }
        print("🟢 MealVC.generateWeekDays: Выбран индекс \(selectedDayIndexPath?.description ?? "nil"), Дата: \(days[selectedDayIndexPath!.item].date)")
    }

    private func configureViewsInitially() {
        daysView.configure(with: days, selectedIndexPath: selectedDayIndexPath)
        categoriesView.configure(with: categories)
        updateMacroViews(currentKcal: 0, totalKcal: 0, carbs: 0, protein: 0, fat: 0)
    }

    private func loadInitialData() {
        if let initialIndexPath = selectedDayIndexPath, initialIndexPath.item < days.count {
            let initialDate = days[initialIndexPath.item].date
            print("🟡 MealVC.loadInitialData: Запускаем loadData для даты: \(initialDate)")
            loadData(for: initialDate)
        } else if let firstDay = days.first {
            print("⚠️ Не удалось определить начальный день, используем первый.")
            selectedDayIndexPath = IndexPath(item: 0, section: 0)
            loadData(for: firstDay.date)
        } else {
            print("⚠️ Дни не сгенерированы, не могу загрузить данные.")
            showErrorAlert(message: "Не удалось загрузить информацию о днях.")
            updateMacroViews(currentKcal: 0, totalKcal: 0, carbs: 0, protein: 0, fat: 0)
        }
    }

    // MARK: - Data Loading
    private func loadData(for date: Date) {
        print("🔄 MealVC.loadData: Получен запрос для даты: \(date)")
        currentDataTask?.cancel()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        print("🔄 Запуск загрузки данных для даты: \(dateString)")

        currentDataTask = Task {
            do {
                let (totalMeals, requirements) = try await viewModel.fetchMealData(for: date)
                try Task.checkCancellation()
                updateMacroViews(with: totalMeals, requirements: requirements)
                print("✅ Данные успешно загружены для \(dateString)")

            } catch is CancellationError {
                print("🔻 Загрузка данных отменена для даты: \(dateString)")
            } catch {
                print("❌ Ошибка при загрузке данных для \(dateString): \(error.localizedDescription)")
                showErrorAlert(message: "Не удалось загрузить данные о питании: \(error.localizedDescription)")
                updateMacroViews(currentKcal: 0, totalKcal: 0, carbs: 0, protein: 0, fat: 0)
            }
        }
    }

    // MARK: - UI Update
    private func updateMacroViews(with totalMeals: TotalMealValuesDTO, requirements: NutritionRequirementsDTO) {
        // ---- ВАЖНО: ИСПОЛЬЗУЙ ПРАВИЛЬНЫЕ ИМЕНА ПОЛЕЙ ИЗ ТВОИХ DTO ----
        // ---- ЗАМЕНИ ЭТИ ПРИМЕРЫ НА РЕАЛЬНЫЕ ИМЕНА ----

        let currentKcal = Int(totalMeals.totalCal)
        let totalKcal = Int(requirements.calories)
        let carbs = Int(totalMeals.totalCarbs)
        let protein = Int(totalMeals.totalProtein)
        let fat = Int(totalMeals.totalFat)

        print("⚪️ MealVC.updateMacroViews: Пришли DTO: totalMeals=\(totalMeals), requirements=\(requirements)")
        print("⚪️ MealVC.updateMacroViews: Обновляем UI: currentKcal=\(currentKcal), totalKcal=\(totalKcal), ...")
        updateMacroViews(currentKcal: currentKcal, totalKcal: totalKcal, carbs: carbs, protein: protein, fat: fat)
    }

    private func updateMacroViews(currentKcal: Int, totalKcal: Int, carbs: Int, protein: Int, fat: Int) {
        macroIndicatorView.update(currentKcal: currentKcal, totalKcal: totalKcal)
        macroSummaryView.update(carbs: carbs, protein: protein, fat: fat)
    }

    private func fetchKetoMeals(categoryName: String) {
        print("Загрузка кето-блюд для категории (из VC): \(categoryName)...")
    }

    // MARK: - Error Handling
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            if self.view.window != nil {
                 self.present(alert, animated: true)
            }
        }
    }

}


// MARK: - DaysHorizontalViewDelegate
extension MealViewController: DaysHorizontalViewDelegate {
    func daysHorizontalView(_ view: DaysHorizontalView, didSelectDay date: Date, at indexPath: IndexPath) {
        print("🗓️ Делегат сработал: Выбран день \(date) по индексу \(indexPath)")
        self.selectedDayIndexPath = indexPath
        loadData(for: date)
    }
}

// MARK: - CategoriesHorizontalViewDelegate
extension MealViewController: CategoriesHorizontalViewDelegate {
    func categoriesHorizontalView(_ view: CategoriesHorizontalView, didSelectCategory category: CategoryEntity) {
        print("🗂️ Выбрана категория: \(category.categoryName) (ID: \(category.categoryId))")
        fetchKetoMeals(categoryName: category.categoryName)
    }
}
