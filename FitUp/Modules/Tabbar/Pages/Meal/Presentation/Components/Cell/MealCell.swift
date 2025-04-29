//
//  MealCell.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 25.04.25.
//
import UIKit
import Kingfisher

class MealCell: UICollectionViewCell {
    
    static let identifier = "MealCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fatStack = CustomMacroStack()
    private lazy var proteinStack = CustomMacroStack()
    private lazy var carbsStack = CustomMacroStack()
    
    private lazy var macrosStackView: UIStackView = {
        fatStack.setDescription("Fat")
        proteinStack.setDescription("Protein")
        carbsStack.setDescription("Carbs")
        
        let stack = UIStackView(arrangedSubviews: [fatStack, proteinStack, carbsStack])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, macrosStackView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(contentStackView)
        contentView.backgroundColor = Resources.Colors.whiteCellColore
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        let padding: CGFloat = 0 // Let the collection view layout handle spacing if possible
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: padding),
            contentView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: padding),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75)
        ])
    }
    
    func configure(with userMealDTO: UserMealDTO) {
        let meal = userMealDTO.meal
        let quantity = Double(userMealDTO.quantity)
        
        let unitText: String
        switch meal.unitType {
        case .GRAM:
            unitText = "\(Int(quantity)) g"
        case .MILLILITER:
            unitText = "\(Int(quantity)) ml"
        case .PIECE:
            unitText = "\(Int(quantity)) pc"
        case .PORTION:
            unitText = "\(Int(quantity)) portion"
        }
        
        nameLabel.text = "\(meal.name.capitalized) \(unitText)"
        
        fatStack.setValue(String(format: "%.0f g", meal.fat * quantity))
        proteinStack.setValue(String(format: "%.0f g", meal.protein * quantity))
        carbsStack.setValue(String(format: "%.0f g", meal.carbs * quantity))
        
        imageView.setImageOptimized(from: meal.image)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        fatStack.setValue("")
        proteinStack.setValue("")
        carbsStack.setValue("")
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
