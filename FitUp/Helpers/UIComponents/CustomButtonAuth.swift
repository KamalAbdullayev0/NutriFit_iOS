//
//  ButtonAuth.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

class CustomButtonAuth: UIButton {
    init(
        title: String,
        height: CGFloat = 60,
        width: CGFloat = 60,
        textColor: UIColor = .white,
        backgroundColor: UIColor = Resources.Colors.green,
        font: UIFont = Resources.AppFont.bold.withSize(18),
        cornerRadius: CGFloat? = 0,
        action: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        configure(
            title: title,
            height: height,
            width: width,
            textColor: textColor,
            backgroundColor: backgroundColor,
            font: font,
            cornerRadius: cornerRadius,
            action: action
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    private func configure(
        title: String,
        height: CGFloat,
        width: CGFloat?,
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
        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        self.action = action
    }
    
    private var action: (() -> Void)?
    
    @objc private func handleTap() {
        animateTap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.action?()
        }
    }
    
    private func animateTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
    
}
