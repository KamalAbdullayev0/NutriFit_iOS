//
//  NavigationBar.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.05.25.
//
import UIKit

final class SearchNavigationBarConfigurator {
    
    static func configure(for viewController: UIViewController,
                          title: String,
                          backAction: Selector,
                          moreAction: Selector) {
        
        viewController.navigationItem.hidesBackButton = true
        
        let titleViewContainer = UIView()
        
        // Back Button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(viewController, action: backAction, for: .touchUpInside)
        
        // Fake SearchBar
        let searchBarView = UIView()
        searchBarView.backgroundColor = .tertiarySystemBackground
        searchBarView.layer.cornerRadius = 10
        
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryLabel
        
        let searchLabel = UILabel()
        searchLabel.text = title
        searchLabel.textColor = .secondaryLabel
        searchLabel.font = .systemFont(ofSize: 17)
        
        // More Button
        let moreButton = UIButton(type: .system)
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .label
        moreButton.addTarget(viewController, action: moreAction, for: .touchUpInside)
        
        // Add subviews and setup constraints
        [backButton, searchBarView, moreButton, searchIcon, searchLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchBarView.addSubview(searchIcon)
        searchBarView.addSubview(searchLabel)
        
        titleViewContainer.addSubview(backButton)
        titleViewContainer.addSubview(searchBarView)
        titleViewContainer.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: titleViewContainer.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: titleViewContainer.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchBarView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            searchBarView.centerYAnchor.constraint(equalTo: titleViewContainer.centerYAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 36),
            
            moreButton.leadingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: 8),
            moreButton.trailingAnchor.constraint(equalTo: titleViewContainer.trailingAnchor),
            moreButton.centerYAnchor.constraint(equalTo: titleViewContainer.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchIcon.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 8),
            searchIcon.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            
            searchLabel.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchLabel.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -8),
            searchLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor)
        ])
        
        viewController.navigationItem.titleView = titleViewContainer
    }
}
