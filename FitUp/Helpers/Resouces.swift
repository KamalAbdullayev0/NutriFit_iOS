//
//  Resources.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 12.01.25.
//

import UIKit

enum Resources {
    
    enum Colors {
        static let background = UIColor(hexString: "#E8E8BF")
        static let orange = UIColor(hexString: "#FF9900")
        static let darkGreen = UIColor(hexString: "#1D9229")
        static let green = UIColor(hexString: "#42B83D")
        static let notification = UIColor(hexString: "#EEEEED")
    }
    enum AppFont: String {
        case regular = "Satoshi-Regular"
        case bold = "Satoshi-Bold"
        case medium = "Satoshi-Medium"
        case light = "Satoshi-Light"
        case black = "Satoshi-Black"
        
        func withSize(_ size: CGFloat) -> UIFont? {
            return UIFont(name: self.rawValue, size: size)
        }
    }
}
