//
//  DietViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

class MealViewController: UIViewController {
    private let viewModel: MealViewModel
    
    private var currentDataTask: Task<Void, Never>?
    private var days: [DayData] = []
    private var selectedDayIndexPath: IndexPath?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var categories: [CategoryEntity] = [
        CategoryEntity(categoryId: "1", categoryName: "Breakfast", categoryEmoji: "🍳"),
        CategoryEntity(categoryId: "2", categoryName: "Lunch", categoryEmoji: "🍲"),
        CategoryEntity(categoryId: "3", categoryName: "Dinner", categoryEmoji: "🥗"),
        CategoryEntity(categoryId: "4", categoryName: "Snack", categoryEmoji: "🍎"),
        CategoryEntity(categoryId: "5", categoryName: "Dessert", categoryEmoji: "🍰"),
        CategoryEntity(categoryId: "6", categoryName: "Drinks", categoryEmoji: "🍹")
    ]
    
    private lazy var daysView: DaysHorizontalView = {
        let view = DaysHorizontalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    private lazy var macroIndicatorView: MacroIndicatorView = {
        let view = MacroIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var macroSummaryView: MacroSummaryView = {
        let view = MacroSummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var categoriesView: CategoriesHorizontalView = {
        let view = CategoriesHorizontalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    private lazy var mealTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today's meals"
        label.font = Resources.AppFont.bold.withSize(24)
        label.textColor = Resources.Colors.todayslabelcolor
        return label
    }()
    private lazy var mealView: MealHorizontalView = {
        let view = MealHorizontalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // view.delegate = self // If you add a delegate protocol to MealHorizontalView for callbacks
        return view
    }()
    
    
    
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
        setupGradientBackground()
        setupViews()
        setupConstraints()
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
            UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(daysView)
        contentView.addSubview(macroIndicatorView)
        contentView.addSubview(macroSummaryView)
        contentView.addSubview(categoriesView)
        contentView.addSubview(mealTitleLabel)
        contentView.addSubview(mealView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            daysView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            daysView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            daysView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            daysView.heightAnchor.constraint(equalToConstant: 100),
            
            macroIndicatorView.topAnchor.constraint(equalTo: daysView.bottomAnchor, constant: 15),
            macroIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            macroSummaryView.topAnchor.constraint(equalTo: macroIndicatorView.bottomAnchor, constant: 25),
            macroSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            macroSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            macroSummaryView.heightAnchor.constraint(equalToConstant: 70),
            
            categoriesView.topAnchor.constraint(equalTo: macroSummaryView.bottomAnchor, constant: 12),
            categoriesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoriesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 100),
            
            mealTitleLabel.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 12),
            mealTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mealTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            mealView.topAnchor.constraint(equalTo: mealTitleLabel.bottomAnchor, constant: 4),
            mealView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mealView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mealView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
    }
    
    private func configureViewsInitially() {
        daysView.configure(with: days, selectedIndexPath: selectedDayIndexPath)
        categoriesView.configure(with: categories)
        updateMacroViews(currentKcal: 0, totalKcal: 0, carbs: 0, protein: 0, fat: 0)
    }
    
    private func loadInitialData() {
        if let initialIndexPath = selectedDayIndexPath, initialIndexPath.item < days.count {
            let initialDate = days[initialIndexPath.item].date
            loadData(for: initialDate)
        } else if let firstDay = days.first {
            selectedDayIndexPath = IndexPath(item: 0, section: 0)
            loadData(for: firstDay.date)
        } else {
            showErrorAlert(message: "Pajcakc")
            updateMacroViews(currentKcal: 0, totalKcal: 0, carbs: 0, protein: 0, fat: 0)
        }
    }
    
    // MARK: - Data Loading
    private func loadData(for date: Date) {
        currentDataTask?.cancel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        currentDataTask = Task {
            do {
                let (totalMeals, requirements,usermeal) = try await viewModel.fetchMealData(for: date)
                try Task.checkCancellation()
                updateMacroViews(with: totalMeals, requirements: requirements)
                mealView.configure(with: usermeal)
                
            } catch is CancellationError {
                print("\(dateString)")
            } catch {
                showErrorAlert(message: "PB \(error.localizedDescription)")
                updateMacroViews(currentKcal: 0, totalKcal: 0, carbs: 0, protein: 0, fat: 0)
                mealView.configure(with: [])
            }
        }
    }
    
    // MARK: - UI Update
    private func updateMacroViews(with totalMeals: TotalMealValuesDTO, requirements: NutritionRequirementsDTO) {
        
        
        let currentKcal = Int(totalMeals.totalCal)
        let totalKcal = Int(requirements.calories)
        let carbs = Int(totalMeals.totalCarbs)
        let protein = Int(totalMeals.totalProtein)
        let fat = Int(totalMeals.totalFat)
        
        updateMacroViews(currentKcal: currentKcal, totalKcal: totalKcal, carbs: carbs, protein: protein, fat: fat)
    }
    
    private func updateMacroViews(currentKcal: Int, totalKcal: Int, carbs: Int, protein: Int, fat: Int) {
        macroIndicatorView.update(currentKcal: currentKcal, totalKcal: totalKcal)
        macroSummaryView.update(carbs: carbs, protein: protein, fat: fat)
    }
    
    private func fetchKetoMeals(categoryName: String) {
        print("\(categoryName)...")
    }
    
    // MARK: - Error Handling
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "PBasck", message: message, preferredStyle: .alert)
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
        self.selectedDayIndexPath = indexPath
        loadData(for: date)
    }
}

// MARK: - CategoriesHorizontalViewDelegate
extension MealViewController: CategoriesHorizontalViewDelegate {
    func categoriesHorizontalView(_ view: CategoriesHorizontalView, didSelectCategory category: CategoryEntity) {
        fetchKetoMeals(categoryName: category.categoryName)
    }
}
