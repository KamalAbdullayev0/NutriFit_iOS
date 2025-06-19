//
//  ProfileViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.06.25.
//

import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let menuOptions = MockUserProfile.menuOptions
    
    
    private var imageLoadTask: Task<Void, Error>?
    
    private let viewModel: ProfileViewModel
    private var userProfile: UserProfileDTO?
    private var userRequirments: NutritionRequirementsDTO?
    
    var onLogoutTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        
        setupNavigationBar()
        setupCollectionView()
        registerCells()
        
        setupViewModelCallbacks()
        fetchProfileData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Resources.AppFont.bold.withSize(24)
        ]
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGray6
        
    }
    private func registerCells() {
        // Register header
        collectionView.register(
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier
        )
        collectionView.register(
            AITrainerButtonCell.self,
            forCellWithReuseIdentifier: AITrainerButtonCell.reuseIdentifier
        )
        collectionView.register(OptionCollectionCell.self, forCellWithReuseIdentifier: OptionCollectionCell.reuseIdentifier)
    }
    private func fetchProfileData() {
        Task {
            do {
                let profile = try await viewModel.fetchUserProfile()
                let requirments = try await viewModel.fetchUserRequirements()
                self.userRequirments = requirments
                self.userProfile = profile
                self.collectionView.reloadSections(IndexSet(integer: 0))
                
            } catch {
                print("❌ Failed to fetch user profile: \(error)")
            }
        }
    }
    private func setupViewModelCallbacks() {
        viewModel.onLogoutSuccess = { [weak self] in
            print("ProfileViewController: Received logout success from ViewModel. Calling coordinator/parent.")
            self?.onLogoutTapped?()
        }
    }
}



// MARK: - UICollectionViewDataSource
extension ProfileViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProfileSection.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentSection = ProfileSection(rawValue: section) else { return 0 }
        return currentSection.itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = ProfileSection(rawValue: indexPath.section) else { fatalError("Unknown section") }
        
        switch section {
        case .aiTrainer:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AITrainerButtonCell.reuseIdentifier, for: indexPath) as! AITrainerButtonCell
            return cell
        case .header:
            fatalError("Header section should not have items")
        case .optionsMenu:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionCell.reuseIdentifier, for: indexPath) as! OptionCollectionCell
            let totalRows = collectionView.numberOfItems(inSection: indexPath.section)
            var position: CellPosition
            
            if totalRows == 1 {
                position = .single
            } else if indexPath.item == 0 {
                position = .first
            } else if indexPath.item == totalRows - 1 {
                position = .last
            } else {
                position = .middle
            }
            
            // cell konfiq
            cell.roundCorners(for: position)
            cell.setSeparatorVisibility(isHidden: (position == .last || position == .single))
            cell.configureCell(with: menuOptions[indexPath.item])
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let section = ProfileSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        switch section {
        case .header:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.reuseIdentifier, for: indexPath) as! ProfileHeaderView
            if let userProfile = userProfile, let userRequirments = userRequirments {
                header.configure(with: userProfile, requirments: userRequirments)
            }
            return header
        default:
            //
            return UICollectionReusableView()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = ProfileSection(rawValue: indexPath.section) else { return .zero }
        let contentWidth = view.frame.width - 40
        
        switch section {
        case .aiTrainer:
            return CGSize(width: contentWidth, height: 58)
        case .optionsMenu:
            return CGSize(width: contentWidth, height: 70)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: view.frame.width, height: 330) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = ProfileSection(rawValue: section) else { return .zero }
        switch section {
        case .aiTrainer:
            return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        case .optionsMenu:
            return UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ProfileSection(rawValue: section) == .optionsMenu ? 0 : 10
    }
    
    // MARK: - Delegate (ОБРАБОТКА НАЖАТИЙ)
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Снимаем выделение для красивой анимации
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let section = ProfileSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .aiTrainer:
            print("Нажата кнопка: ★ AI Personal Trainer")
            
        case .optionsMenu:
            let selectedOption = menuOptions[indexPath.item]
            print("Нажата ячейка: \(selectedOption.title)")
            if selectedOption.title == "Logout" {
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
                    self.viewModel.logout()
                }))
                present(alert, animated: true)
            }
            
        default:
            break
        }
    }
}
