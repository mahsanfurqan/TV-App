import SwiftUI

enum AppTheme {
    enum Colors {
        static let canvas = Color(red: 0.035, green: 0.035, blue: 0.055)
        static let surface = Color(red: 0.085, green: 0.085, blue: 0.115)
        static let elevated = Color(red: 0.125, green: 0.125, blue: 0.16)
        static let accent = Color(red: 1.0, green: 0.39, blue: 0.08)
        static let accentSoft = Color(red: 1.0, green: 0.58, blue: 0.20)
        static let secondaryText = Color.white.opacity(0.68)
        static let subtle = Color.white.opacity(0.10)
    }

    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 24
        static let section: CGFloat = 32
    }

    enum Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
    }
}
