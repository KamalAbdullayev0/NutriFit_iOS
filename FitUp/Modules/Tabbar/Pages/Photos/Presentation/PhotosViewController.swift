//
//  PhotosViewController.swift
//  Netwrok
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

class PhotosViewController: UICollectionViewController {
    private let photos = (1...20).map { "Photo \($0)" }
    private let cellID = "photoCell"
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        title = "Activiteis"
        setupLayout()
    }
    
    private func setupLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 10
        
        let label = UILabel(frame: cell.bounds)
        label.text = photos[indexPath.row]
        label.textAlignment = .center
        cell.addSubview(label)
        
        return cell
    }
}
