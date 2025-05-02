//
//  Resources.swift
//  M10-App
//
//  Created by Kamal Abdullayev on 12.01.25.
//

import UIKit

enum Resources {
    
    enum Colors {
        static let black = UIColor(hexString: "#000000")
        static let white = UIColor(hexString: "#FFFFFF")
        static let background = UIColor(hexString: "#E8E8BF")
        static let orange = UIColor(hexString: "#FF9900")
        static let green = UIColor(hexString: "#42B83D")
        static let redColor = UIColor(hexString: "#EA3325")
        
        static let greyColor = UIColor(hexString: "#F7F8F9")
        static let greyBorderColor = UIColor(hexString: "#E8ECF4")//F5F7FA//E8ECF4//D6F5E3
        static let whiteCellColore = UIColor(hexString: "#FBFCFE")
        static let greyDark = UIColor(hexString: "#6A707C")
        static let greyTextColor = UIColor(hexString: "#8391A1")
        //E5E5E5
        static let greyChooseColor = UIColor(hexString: "#E5E5E5")
        static let todayslabelcolor = UIColor(hexString: "#a2d3b")
        static let notacountbackground = UIColor(hexString: "#DAD7D7")
        
        static let greenCalendar = UIColor(hexString: "#66c893")//F5F7FA//E8ECF4//D6F5E3//66c893//A8E6A1
        static let brown = UIColor(hexString: "#DB8318")
        static let red = UIColor(hexString: "#FF2C2C")
        static let blue = UIColor(hexString: "#00F0FF")

    }
    enum AppFont: String {
        case regular = "Satoshi-Regular"
        case bold = "Satoshi-Bold"
        case medium = "Satoshi-Medium"
        case light = "Satoshi-Light"
        case black = "Satoshi-Black"
        
        func withSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
}
