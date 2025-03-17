//
//  SplashVC.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 17.03.25.
//
import UIKit

class SplashScreenViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.startAnimating()
        
        // Simulate a delay for the splash screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.transitionToMainApp()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView, activityIndicator])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func transitionToMainApp() {
        guard let window = UIApplication.shared.windows.first else { return }
        let navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
