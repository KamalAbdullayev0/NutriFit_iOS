//
//  RegisterController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

final class RegisterController: UIViewController {
    private var viewModel: RegisterViewModel
    
    private let nutrifitImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "yazi"))
        imageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.logobackground
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.01).cgColor
        return view
    }()
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Resources.Colors.orange
        let backImage = UIImage(systemName: "chevron.left")!
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        let titleStackView = UIStackView(arrangedSubviews: [nutrifitImageView])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .center
        navigationItem.titleView = titleStackView
        
    }
    
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
    
    private let fullNameTextField = CustomTextField(
        placeholder: "Full Name",
        height: 64,
        width: 320,
        icon: UIImage(systemName: "person.fill")
    )
    
    private let emailTextField = CustomTextField(
        placeholder: "Enter Email",
        height: 64,
        width: 320,
        icon: UIImage(systemName: "envelope.fill")
    )
    
    private let passwordTextField = CustomTextField(
        placeholder: "Enter Password",
        height: 64,
        width: 320,
        icon: UIImage(systemName: "lock.fill")
    )
    
    lazy var registerButton = CustomButtonAuth(
        title: "Register",
        height: 64,
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
    private lazy var registerstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, textFieldWithStack,registerButton])
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    private lazy var registerWithStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orRegisterLabel, iconStackView])
        stack.axis = .horizontal
        stack.spacing = 160
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        setupGestureRecognizers()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(logoContainerView)
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        logoContainerView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(registerstack)
        registerstack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(registerWithStack)
        registerWithStack.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            logoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoContainerView.widthAnchor.constraint(equalToConstant: 200),
            logoContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.topAnchor.constraint(equalTo: logoContainerView.topAnchor, constant: 20),
            logoImageView.bottomAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: -20),
            logoImageView.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor, constant: 20),
            logoImageView.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: -20),
            
            registerstack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerstack.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 20),
            registerstack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerstack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            registerWithStack.topAnchor.constraint(equalTo: registerstack.bottomAnchor, constant: 20),
            registerWithStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerWithStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    private func setupGestureRecognizers() {
        let appleTap = UITapGestureRecognizer(target: self, action: #selector(handleAppleSignIn))
        appleIcon.addGestureRecognizer(appleTap)
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(handleGoogleSignIn))
        googleIcon.addGestureRecognizer(googleTap)
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleAppleSignIn() {
        print("Apple Sign In tapped")
    }
    
    @objc private func handleGoogleSignIn() {
        print("Google Sign In tapped")
    }
    
}
