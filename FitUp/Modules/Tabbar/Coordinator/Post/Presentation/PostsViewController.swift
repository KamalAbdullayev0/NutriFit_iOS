//
//  PostsViewController.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit
class SectionBackgroundDecorationView: UICollectionReusableView {
    static let reuseIdentifier = "SectionBackgroundDecorationView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground // или любой другой цвет фона для группы ячеек
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}
//
//  PostsViewController.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

class PostsViewController: UIViewController, UICollectionViewDelegate {
    
    private let menuOptions = MockUserProfile.menuOptions
    
    private var imageLoadTask: Task<Void, Error>?
    
    private let viewModel: ProfileViewModel
    private var userProfile: UserProfileDTO?
    private var userRequirments: NutritionRequirementsDTO?
    
    // MARK: - UI Elements
    private var collectionView: UICollectionView!

    // MARK: - Lifecycle
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        registerCellsAndViews()
        setupConstraints()
        
        fetchProfileData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemGray6 // Фон для всего view controller
    }
    
    private func setupCollectionView() {
        // Создаем layout с помощью нашей фабричной функции
        let layout = createLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }

    private func registerCellsAndViews() {
        // Register Header
        collectionView.register(
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier
        )
        
        // Register Cells
        collectionView.register(AITrainerButtonCell.self, forCellWithReuseIdentifier: AITrainerButtonCell.reuseIdentifier)
        collectionView.register(OptionCollectionCell.self, forCellWithReuseIdentifier: OptionCollectionCell.reuseIdentifier)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchProfileData() {
        Task {
            do {
                let profile = try await viewModel.fetchUserProfile()
                let requirments = try await viewModel.fetchUserRequirements()
                self.userRequirments = requirments
                self.userProfile = profile
                self.collectionView.reloadData() // Перезагружаем все данные
            } catch {
                print("❌ Failed to fetch user profile: \(error)")
            }
        }
    }
}

// MARK: - Compositional Layout Factory
extension PostsViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self, let sectionType = ProfileSection(rawValue: sectionIndex) else { return nil }
            
            switch sectionType {
            case .header:
                // header
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Группа должна иметь размер, но т.к. ячеек нет, делаем ее очень маленькой.
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                // Создаем и привязываем хедер
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [sectionHeader]
                return section
                
            case .aiTrainer:
                // Секция с одной большой кнопкой
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(58))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20)
                return section
                
            case .optionsMenu:
                //birininolcusu
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                // elave edirik olcunu elemente
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // qrupun hundurluyunu olcmek ucun munuoptionsdan sayini gotururuk
                let groupHeight = NSCollectionLayoutDimension.estimated(CGFloat(self.menuOptions.count) * 70)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                
                //grupu itemlerler yaradiriq
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                //sectiona qrupu add edirik daha sora olculerini yaziriq
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(
                    elementKind: SectionBackgroundDecorationView.reuseIdentifier
                )
                section.decorationItems = [backgroundItem]
                return section
            }
        }
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.reuseIdentifier)
        
        return layout
    }
}


// MARK: - UICollectionViewDataSource
extension PostsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProfileSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentSection = ProfileSection(rawValue: section) else { return 0 }
        
        // Для секции хедера по-прежнему 0 ячеек
        if currentSection == .header { return 0 }
        
        return currentSection.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = ProfileSection(rawValue: indexPath.section) else { fatalError("Unknown section") }
        
        switch section {
        case .aiTrainer:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AITrainerButtonCell.reuseIdentifier, for: indexPath) as! AITrainerButtonCell
            return cell
            
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
            
            // Логика скругления углов теперь не нужна, ее делает `decorationItem`
            // cell.roundCorners(for: position)
            
            // А вот разделитель все еще нужен
            cell.setSeparatorVisibility(isHidden: (position == .last || position == .single))
            cell.configureCell(with: menuOptions[indexPath.item])
            return cell
            
        case .header:
            // Этот case никогда не будет вызван, т.к. у секции 0 нет ячеек.
            fatalError("Header section should not have items")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let sectionType = ProfileSection(rawValue: indexPath.section),
              sectionType == .header else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.reuseIdentifier, for: indexPath) as! ProfileHeaderView
        if let userProfile = userProfile, let userRequirments = userRequirments {
            header.configure(with: userProfile, requirments: userRequirments)
        }
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension PostsViewController {
    // Методы UICollectionViewDelegateFlowLayout УДАЛЕНЫ, так как вся их логика теперь в `createLayout()`
    
    // MARK: - Delegate (ОБРАБОТКА НАЖАТИЙ)
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Снимаем выделение для красивой анимации
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let section = ProfileSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .aiTrainer:
            print("Нажата кнопка: ★ AI Personal Trainer")
            
        case .optionsMenu:
            let selectedOption = menuOptions[indexPath.item]
            print("Нажата ячейка: \(selectedOption.title)")
            
        default:
            break
        }
    }
}
