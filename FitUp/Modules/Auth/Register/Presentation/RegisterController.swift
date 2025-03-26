//
//  RegisterController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

final class RegisterController: UIViewController {
    private var viewModel: RegisterViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Start your journey"
        label.font = Resources.AppFont.medium.withSize(36)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Join NutriFit today and unlock your personalized path to fitness, nutrition, and well-being."
        label.font = Resources.AppFont.medium.withSize(16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.systemGray6
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let fullNameTextField = CustomTextField(
        placeholder: "Full Name",
        height: 70,
        width: 320,
        icon: UIImage(systemName: "person.fill")
    )
    
    private let emailTextField = CustomTextField(
        placeholder: "Enter Email",
        height: 70,
        width: 320,
        icon: UIImage(systemName: "envelope.fill")
    )
    
    private let passwordTextField = CustomTextField(
        placeholder: "Enter Password",
        height: 70,
        width: 320,
        icon: UIImage(systemName: "lock.fill")
    )
    
    lazy var registerButton = CustomButtonAuth(
        title: "Register",
        height: 70,
        textColor: .white,
        backgroundColor: Resources.Colors.green,
        font: Resources.AppFont.medium.withSize(22),
        cornerRadius: 16
    ) {
        [weak self] in
        print("basdun")
    }
    private let orRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "Or register with"
        label.font = Resources.AppFont.regular.withSize(14)
        label.textColor = .black
        return label
    }()
    private let appleIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "apple"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let googleIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "google"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var iconStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [googleIcon, appleIcon])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    private lazy var registerWithStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orRegisterLabel, iconStackView])
        stack.axis = .horizontal
        stack.spacing = 200
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var textFieldWithStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        setupBindings()
        let appleTap = UITapGestureRecognizer(target: self, action: #selector(handleAppleSignIn))
        appleIcon.addGestureRecognizer(appleTap)
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(handleGoogleSignIn))
        googleIcon.addGestureRecognizer(googleTap)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel,textFieldWithStack, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        registerWithStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerWithStack)
        
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerWithStack.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 20),
            registerWithStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerWithStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
        ])
    }
    
//    private func setupBindings() {
//        
//    }
    @objc private func handleAppleSignIn() {
        print("Apple Sign In tapped")
        // Здесь вызываем функцию авторизации через Apple
    }
    
    // Действие по нажатию на Google Sign In
    @objc private func handleGoogleSignIn() {
        print("Google Sign In tapped")
        // Здесь вызываем функцию авторизации через Google
    }
    
}
