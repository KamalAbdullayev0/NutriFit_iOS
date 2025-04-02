//
//  CustomButtonContinue.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 01.04.25.
//
import UIKit

class CustomButtonContinue: UIButton {
    init(
        title: String = "Continue",
        height: CGFloat = 40,
        weight: CGFloat = 120,
        textColor: UIColor = Resources.Colors.white,
        backgroundColor: UIColor = Resources.Colors.redColor,
        font: UIFont = Resources.AppFont.medium.withSize(18),
        cornerRadius: CGFloat? = 25,
        action: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        configure(
            title: title,
            height: height,
            weight: weight,
            textColor: textColor,
            backgroundColor: backgroundColor,
            font: font,
            cornerRadius: cornerRadius,
            action: action
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не поддерживается")
    }
    
    private func configure(
        title: String,
        height: CGFloat,
        weight: CGFloat,
        textColor: UIColor,
        backgroundColor: UIColor,
        font: UIFont,
        cornerRadius: CGFloat?,
        action: @escaping () -> Void
    ) {
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius ?? height / 2
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        self.action = action
    }
    
    private var action: (() -> Void)?
    
    @objc private func handleTap() {
        animateTap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            self.action?()
        }
    }
    
    private func animateTap() {
        UIView.animate(withDuration: 0.05, animations: {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.05) {
                self.transform = .identity
            }
        }
    }
}
