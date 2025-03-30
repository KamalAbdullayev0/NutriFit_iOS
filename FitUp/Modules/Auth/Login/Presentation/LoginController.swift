//
//  LoginController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 18.03.25.
//
import UIKit

final class LoginController: UIViewController {
    
    private let viewModel: LoginViewModel
    private let scrollView = UIScrollView()
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Resources.Colors.greyDark
        let backImage = UIImage(systemName: "chevron.left")!
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.numberOfLines = 2
        label.font = Resources.AppFont.bold.withSize(32)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back! Let's continue your journey to a healthier, fitter you with NutriFit."
        label.font = Resources.AppFont.medium.withSize(16)
        label.textAlignment = .left
        label.textColor = Resources.Colors.greyTextColor
        label.numberOfLines = 3
        return label
    }()
    
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
    lazy var loginButton = CustomButtonAuth(
        title: "Sign In",
        height: 64,
        textColor: .white,
        backgroundColor: Resources.Colors.green,
        font: Resources.AppFont.medium.withSize(22),
        cornerRadius: 16
    ) {
        [weak self] in
        print("basdun")
    }
    private let orLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login with"
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
    private lazy var loginWithStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orLoginLabel, iconStackView])
        stack.axis = .horizontal
        stack.spacing = 160
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let notAcountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don\'t have an account?"
        label.font = Resources.AppFont.regular.withSize(14)
        label.textColor = Resources.Colors.greyTextColor
        label.textAlignment = .center
        return label
    }()
    lazy var createAccountButton = CustomButtonAuth(
        title: "Register Now",
        height: 64,
        textColor: .white,
        backgroundColor: Resources.Colors.notacountbackground,
        font: Resources.AppFont.medium.withSize(22),
        cornerRadius: 16
    ) {
        [weak self] in
        self?.viewModel.goToRegister()
        print("basdun3")
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var labelWithStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private lazy var textFieldWithStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    private lazy var loginstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginWithStack,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private lazy var notAccountStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notAcountLabel, createAccountButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalSpacing
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        setupGestureRecognizers()
    }
    private func setupUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        setupScrollView()
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        [labelWithStack, textFieldWithStack, loginstack,notAccountStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        notAccountStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notAccountStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            labelWithStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 30),
            labelWithStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelWithStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            textFieldWithStack.topAnchor.constraint(equalTo: labelWithStack.bottomAnchor, constant: 24),
            textFieldWithStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textFieldWithStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            loginstack.topAnchor.constraint(equalTo: textFieldWithStack.bottomAnchor, constant: 30),
            loginstack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginstack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            notAccountStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            notAccountStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            notAccountStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
            
        ])
        
    }
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func setupGestureRecognizers() {
        addTapGesture(to: appleIcon, action: #selector(handleAppleSignIn))
        addTapGesture(to: googleIcon, action: #selector(handleGoogleSignIn))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    private func addTapGesture(to view: UIView, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
