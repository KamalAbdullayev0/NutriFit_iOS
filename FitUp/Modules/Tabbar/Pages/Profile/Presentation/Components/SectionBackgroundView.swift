//
//  SectionBackgroundView.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.06.25.
//
import UIKit

class SectionBackgroundView: UICollectionReusableView {
    static let reuseIdentifier = "SectionBackgroundView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
