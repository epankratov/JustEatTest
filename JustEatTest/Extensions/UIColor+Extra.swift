//
//  UIColor+Extra.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 24.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }

    static func Red() -> UIColor {
        return self.init(rgb: 0xF44336)
    }

    static func Pink() -> UIColor {
        return self.init(rgb: 0xE91E63)
    }

    static func Purple() -> UIColor {
        return self.init(rgb: 0x9C27B0)
    }

    static func DeepPurple() -> UIColor {
        return self.init(rgb: 0x067AB7)
    }

    static func Indigo() -> UIColor {
        return self.init(rgb: 0x3F51B5)
    }

    static func Blue() -> UIColor {
        return self.init(rgb: 0x2196F3)
    }

    static func LightBlue() -> UIColor {
        return self.init(rgb: 0x03A9F4)
    }

    static func Cyan() -> UIColor {
        return self.init(rgb: 0x00BCD4)
    }

    static func Teal() -> UIColor {
        return self.init(rgb: 0x009688)
    }

    static func Green() -> UIColor {
        return self.init(rgb: 0x4CAF50)
    }

    static func LightGreen() -> UIColor {
        return self.init(rgb: 0x8BC34A)
    }

    static func Lime() -> UIColor {
        return self.init(rgb: 0xCDDC39)
    }

    static func Yellow() -> UIColor {
        return self.init(rgb: 0xFFEB3B)
    }

    static func Amber() -> UIColor {
        return self.init(rgb: 0xFFC107)
    }

    static func Orange() -> UIColor {
        return self.init(rgb: 0xFF9800)
    }

    static func DeepOrange() -> UIColor {
        return self.init(rgb: 0xFF5722)
    }

    static func Brown() -> UIColor {
        return self.init(rgb: 0x795548)
    }

    static func Grey() -> UIColor {
        return self.init(rgb: 0x9E9E9E)
    }

    static func BlueGrey() -> UIColor {
        return self.init(rgb: 0x607D8B)
    }

    static func AmbientGray() -> UIColor {
        return self.init(rgb: 0xEDF1F2)
    }
}
