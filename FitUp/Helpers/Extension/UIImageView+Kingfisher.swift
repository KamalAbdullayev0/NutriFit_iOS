//
//  UIImageView+Kingfisher.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 29.04.25.
//
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageOptimized(from urlString: String?, placeholder: UIImage? = UIImage(systemName: "photo")) {
        kf.cancelDownloadTask()
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        var options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]
        if bounds.size != .zero {
            let processor = DownsamplingImageProcessor(size: bounds.size)
            options.append(.processor(processor))
        }
        
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                if !error.isTaskCancelled && !error.isNotCurrentTask {
                    print("KF Error for \(url): \(error.localizedDescription)")
                    self.image = UIImage(systemName: "exclamationmark.triangle")?.withRenderingMode(.alwaysTemplate)
                    self.tintColor = .systemGray
                }
            }
        }
    }
}
