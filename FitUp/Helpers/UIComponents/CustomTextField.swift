import UIKit

class CustomTextField: UIView, UITextFieldDelegate {
    private let textField = UITextField()
    private let containerView = UIView()
    private let leftIconView = UIImageView()
    private let clearButton = UIButton(type: .system)
    
    var text: String {
            return textField.text ?? ""
    }
    
    var hasError: Bool = false {
        didSet {
            updateBorderColor()
        }
    }
    
    init(placeholder: String, fontSize: CGFloat = 16, height: CGFloat, width: CGFloat, icon: UIImage? = nil) {
        super.init(frame: .zero)
        
        containerView.backgroundColor = Resources.Colors.greyColor
        containerView.layer.cornerRadius = height / 3
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        textField.placeholder = placeholder
        textField.tintColor = Resources.Colors.black
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        containerView.addSubview(textField)
        
        leftIconView.image = icon
        leftIconView.tintColor = Resources.Colors.darkGreen
        leftIconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(leftIconView)
        
        clearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        clearButton.tintColor = Resources.Colors.darkGreen
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.isHidden = true
        containerView.addSubview(clearButton)
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height),
            
            leftIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            leftIconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftIconView.widthAnchor.constraint(equalToConstant: 24),
            leftIconView.heightAnchor.constraint(equalToConstant: 24),
            
            textField.leadingAnchor.constraint(equalTo: leftIconView.trailingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -padding),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 24),
            clearButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        updateBorderColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBorderColor() {
        if hasError {
            containerView.layer.borderColor = Resources.Colors.redColor.cgColor
        } else {
            containerView.layer.borderColor = textField.isFirstResponder ? Resources.Colors.green.cgColor : Resources.Colors.greyColor.cgColor
        }
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hasError = false
        containerView.backgroundColor = .white
        updateBorderColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        containerView.backgroundColor = Resources.Colors.greyColor
        updateBorderColor()
    }
    
    @objc private func textFieldDidChange() {
        clearButton.isHidden = textField.text?.isEmpty ?? true
    }
    
    @objc private func clearText() {
        textField.text = ""
        clearButton.isHidden = true
    }
    
    func setError(_ hasError: Bool) {
        self.hasError = hasError
    }
}
