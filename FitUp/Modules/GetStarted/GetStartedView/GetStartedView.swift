//
//  GetStartedView.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 03.02.25.
//

import UIKit

class GetStartedView: UIViewController {
    private let viewModel: GetStartedViewModel

    init(viewModel: GetStartedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let logoView = SVGImageLoader.loadSVG(named: "logo10lar", width: 400, height: 450,cornerRadius: 0)
    private lazy var getStartedButton: CustomButton = {
        return CustomButton(buttonText: "Daxil ol", height: 70, width: 260) { [weak self] in
            self?.viewModel.didTapGetStarted()
        }
    }()
    private let vectorView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vector")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Resources.Colors.bluedarkColor
        
        let text = "Copyright ⓒ 2024 PashaPay MMC\nAll Rights Reserved"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: Resources.Colors.bluedarkColor,
            .paragraphStyle: paragraphStyle
        ])
        
        label.attributedText = attributedText
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.greenlightColor
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoView)
        view.addSubview(getStartedButton)
        view.addSubview(vectorView)
        view.addSubview(bottomLabel)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        vectorView.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 400),
            logoView.heightAnchor.constraint(equalToConstant: 450),
            
            vectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vectorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vectorView.topAnchor.constraint(equalTo: logoView.bottomAnchor,constant: -400),
            
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            getStartedButton.topAnchor.constraint(equalTo: vectorView.bottomAnchor,constant: -300),
            
            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
        ])
    }

}
