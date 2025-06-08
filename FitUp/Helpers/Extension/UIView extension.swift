//
//  UIView extension.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 07.06.25.
//

import UIKit

extension UIView {
    @discardableResult
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}
extension UIStackView {
    @discardableResult
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}
extension UIImageView {
    @discardableResult
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension UILabel {
    @discardableResult
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

//extension UIImageView{
//    @discardableResult
//    func configure<T: UIImageView>(_ configuration: (T) -> Void) -> T {
//        guard let self = self as? T else { return self as! T }
//        configuration(self)
//        return self
//    }
//}
//extension NSObject {
//    @discardableResult
//    func configure<T: NSObject>(_ configuration: (T) -> Void) -> T {
//        configuration(self as! T)
//        return self as! T
//    }
//}
//extension UIView {
//    @discardableResult
//    func configure(_ configuration: (Self) -> Void) -> Self {
//        configuration(self)
//        return self
//    }
//}
//extension NSObject {
//    @discardableResult
//    func configure(block: (Self) -> Void) -> Self {
//        block(self)
//        return self
//    }
//}
