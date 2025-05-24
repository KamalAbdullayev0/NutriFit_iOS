//
//  MenuItemCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.05.25.
//
import UIKit
import SwipeCellKit // Если используешь

class MenuItemCell: SwipeCollectionViewCell {
    static let reuseIdentifier = "MenuItemCell"
    
    // --- UI Элементы (основные) ---
    private let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.AppFont.medium.withSize(20)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.AppFont.medium.withSize(15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Resources.AppFont.medium.withSize(15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    // --- UI Элементы для нутриентов (без изменений) ---
    private func createNutrientLabel(textAlignment: NSTextAlignment = .natural) -> UILabel { // Изменил .center на .natural или .left
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium) // Шрифт для значения
        label.textColor = .label // Основной цвет текста
        label.textAlignment = textAlignment // Выравнивание текста
        label.numberOfLines = 1 // Обычно значение в одну строку
        return label
    }
    
    // Функция для создания UILabel для ЗАГОЛОВКА нутриента (например, "Fat")
    private func createNutrientTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }
    private lazy var fatValueLabel: UILabel = createNutrientLabel()
    private lazy var fatTitleLabel: UILabel = createNutrientTitleLabel()
    private lazy var proteinValueLabel: UILabel = createNutrientLabel()
    private lazy var proteinTitleLabel: UILabel = createNutrientTitleLabel()
    private lazy var carbsValueLabel: UILabel = createNutrientLabel()
    private lazy var carbsTitleLabel: UILabel = createNutrientTitleLabel()
    
    
    // StackView для Name и Quantity (горизонтальный)
    private lazy var nameQuantityStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, quantityLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .firstBaseline
        return stack
    }()
    
    // StackViews для каждого нутриента (вертикальные: значение над заголовком)
    private lazy var fatStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fatValueLabel, fatTitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var proteinStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [proteinValueLabel, proteinTitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var carbsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [carbsValueLabel, carbsTitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nutrientsDataStackView: UIStackView = {
        
        let stack = UIStackView(arrangedSubviews: [fatStack, proteinStack, carbsStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 12
        return stack
    }()
    
    // Главный текстовый контейнер (слева от картинки)
    // Содержит: nameQuantityStackView, descriptionLabel, nutrientsDataStackView
    private lazy var textInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameQuantityStackView, descriptionLabel, nutrientsDataStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        return stack
    }()
    
    // Разделитель
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground // Фон ячейки
        
        // Добавляем главные элементы в contentView
        contentView.addSubview(itemImageView)
        contentView.addSubview(textInfoStackView)
        contentView.addSubview(dividerView)
        
        // Устанавливаем статические тексты для заголовков нутриентов
        fatTitleLabel.text = "Fat"
        proteinTitleLabel.text = "Protein"
        carbsTitleLabel.text = "Carbs"
        
        setupConstraints()
    }
    private func setupConstraints() {
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            itemImageView.heightAnchor.constraint(equalToConstant: 120),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 1.25),

            textInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            textInfoStackView.trailingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            textInfoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            
            
            // --- dividerView (в самом низу) ---
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: padding), // На всю ширину, без боковых отступов
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: padding),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.kf.cancelDownloadTask()
        itemImageView.image = nil // Плейсхолдер установится в configure
        nameLabel.text = nil
        quantityLabel.text = nil
        fatValueLabel.text = nil
        proteinValueLabel.text = nil
        carbsValueLabel.text = nil
        descriptionLabel.text = nil
        
    }
    
    func configure(with menuItem: MenuItem) {
        nameLabel.text = menuItem.name
        descriptionLabel.text = menuItem.description
        quantityLabel.text = menuItem.quantityInfo
        quantityLabel.isHidden = (menuItem.quantityInfo == nil || menuItem.quantityInfo?.isEmpty == true) // Скрываем, если нет данных
        
        fatValueLabel.text = menuItem.fatValue
        proteinValueLabel.text = menuItem.proteinValue
        carbsValueLabel.text = menuItem.carbsValue
        
        itemImageView.setImageOptimized(from: menuItem.imageName, placeholder: UIImage(systemName: "photo.on.rectangle.angled")) // Используй свой плейсхолдер
    }
}
