//
//  UIColor+Extensions.swift
//  Bookster
//
//  Created by Alexis Gadbin on 22/03/2025.
//

import SwiftUI

extension Color {
    public func toHexString() -> String? {
        let uiColor = UIColor(self)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        else {
            return nil
        }

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }

    public init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var red: Double
        var green: Double
        var blue: Double
        var opacity: Double

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        if length == 6 {
            red = Double((rgb & 0xFF0000) >> 16) / 255.0
            green = Double((rgb & 0x00FF00) >> 8) / 255.0
            blue = Double(rgb & 0x0000FF) / 255.0
            opacity = 1.0
        } else if length == 8 {
            red = Double((rgb & 0xFF00_0000) >> 24) / 255.0
            green = Double((rgb & 0x00FF_0000) >> 16) / 255.0
            blue = Double((rgb & 0x0000_FF00) >> 8) / 255.0
            opacity = Double(rgb & 0x0000_00FF) / 255.0
        } else {
            return nil
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
