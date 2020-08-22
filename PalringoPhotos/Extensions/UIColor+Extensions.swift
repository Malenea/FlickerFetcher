//
//  UIColor+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // MARK: UIColor extensions
    class var charcoalGray: UIColor {
        return UIColor(red: 0.18, green: 0.19, blue: 0.20, alpha: 1.00)
    }

    class func charcoalGray(_ alpha: CGFloat) -> UIColor {
        return charcoalGray.withAlphaComponent(alpha)
    }

    class var offWhite: UIColor {
        return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    }

    class func offWhite(_ alpha: CGFloat) -> UIColor {
        return offWhite.withAlphaComponent(alpha)
    }

    // Content colors
    class var pastelOrange: UIColor {
        return UIColor(red: 1.0, green: 0.85, blue: 0.76, alpha: 1.00)
    }

    class func pastelOrange(_ alpha: CGFloat) -> UIColor {
        return pastelOrange.withAlphaComponent(alpha)
    }

    class var pastelGreen: UIColor {
        return UIColor(red: 0.89, green: 0.94, blue: 0.8, alpha: 1.0)
    }

    class func pastelGreen(_ alpha: CGFloat) -> UIColor {
        return pastelGreen.withAlphaComponent(alpha)
    }

    class var pastelMint: UIColor {
        return UIColor(red: 0.71, green: 0.92, blue: 0.84, alpha: 1.0)
    }

    class func pastelMint(_ alpha: CGFloat) -> UIColor {
        return pastelMint.withAlphaComponent(alpha)
    }

    class var pastelBlue: UIColor {
        return UIColor(red: 0.78, green: 0.81, blue: 0.92, alpha: 1.0)
    }

    class func pastelBlue(_ alpha: CGFloat) -> UIColor {
        return pastelBlue.withAlphaComponent(alpha)
    }

    class func getPastelColors() -> [UIColor] {
        return [pastelOrange, pastelGreen, pastelMint, pastelBlue]
    }

}
