//
//  UIColor.swift
//  Wordsmyther (iOS)
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import SwiftUI

extension UIColor {
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0,
            green: CGFloat = 0,
            blue: CGFloat = 0,
            alpha: CGFloat = 0

        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: (red + percentage/100).clamped(to: 0...1),
                green: (green + percentage/100).clamped(to: 0...1),
                blue: (blue + percentage/100).clamped(to: 0...1),
                alpha: alpha.clamped(to: 0...1)
            )
        } else {
            return nil
        }
    }
}
