//
//  CustomButtonChose.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 01.04.25.
//
import UIKit
class GoalButton: UIButton {
    
    init(
        title: String,
        height: CGFloat = 50,
        textColor: UIColor = Resources.Colors.black,
        backgroundColor: UIColor = Resources.Colors.greyChooseColor,
        font: UIFont = Resources.AppFont.medium.withSize(18),
        cornerRadius: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        configure(
            title: title,
            height: height,
            textColor: textColor,
            backgroundColor: backgroundColor,
            font: font,
            cornerRadius: cornerRadius ?? height / 4,
            action: action
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не поддерживается")
    }
    
    private func configure(
        title: String,
        height: CGFloat,
        textColor: UIColor,
        backgroundColor: UIColor,
        font: UIFont,
        cornerRadius: CGFloat,
        action: @escaping () -> Void
    ) {
        
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = textColor
        config.baseBackgroundColor = backgroundColor
        
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: font
        ]))
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        self.configuration = config
        translatesAutoresizingMaskIntoConstraints = false
        contentHorizontalAlignment = .left
        heightAnchor.constraint(equalToConstant: height).isActive = true
        self.configuration = config
        layer.cornerRadius = cornerRadius // Теперь задается корректно
                clipsToBounds = true
        addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)
    }
}

