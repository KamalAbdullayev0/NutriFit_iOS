//
//  SplashVC.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 17.03.25.
//
import UIKit

class SplashScreenViewController: UIViewController {
    var onComplete: (() -> Void)?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let logotextView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yazi")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.onComplete?()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(logotextView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -80),
            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            logoImageView.heightAnchor.constraint(equalToConstant: 240),
            
            logotextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logotextView.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 72),
            logotextView.widthAnchor.constraint(equalToConstant: 360),
            logotextView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
}
