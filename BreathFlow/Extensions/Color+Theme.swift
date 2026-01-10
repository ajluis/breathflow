import SwiftUI
import UIKit

extension Color {
    static let theme = ThemeColors()
}

struct ThemeColors {
    // Primary brand colors - adaptive
    let primary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.5, green: 0.8, blue: 0.9, alpha: 1.0)  // Brighter cyan for dark
            : UIColor(red: 0.4, green: 0.7, blue: 0.8, alpha: 1.0)  // Original cyan
    })

    let primaryDark = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.4, green: 0.6, blue: 0.7, alpha: 1.0)
            : UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1.0)
    })

    let secondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.5, green: 0.85, blue: 0.75, alpha: 1.0)  // Brighter mint for dark
            : UIColor(red: 0.6, green: 0.8, blue: 0.7, alpha: 1.0)
    })

    // Background colors - adaptive
    let background = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.05, green: 0.07, blue: 0.09, alpha: 1.0)  // Deep navy #0D1117
            : UIColor(red: 0.95, green: 0.97, blue: 0.98, alpha: 1.0)  // Light blue-gray
    })

    // Card background - adaptive
    let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.09, green: 0.11, blue: 0.13, alpha: 1.0)  // Slightly lighter #161B22
            : UIColor.white
    })

    // Text colors - adaptive
    let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.9, green: 0.93, blue: 0.95, alpha: 1.0)  // Off-white #E6EDF3
            : UIColor(red: 0.2, green: 0.25, blue: 0.3, alpha: 1.0)   // Dark gray
    })

    let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.55, green: 0.58, blue: 0.62, alpha: 1.0)  // Muted gray #8B949E
            : UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1.0)
    })

    // Accent colors - adaptive
    let accent = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.0, green: 0.65, blue: 0.45, alpha: 1.0)   // Brighter orange
            : UIColor(red: 0.95, green: 0.6, blue: 0.4, alpha: 1.0)
    })

    let streakColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.0, green: 0.7, blue: 0.3, alpha: 1.0)     // Brighter orange-yellow
            : UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
    })

    // Breath phase colors - adaptive
    let inhaleColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.55, green: 0.8, blue: 0.9, alpha: 1.0)    // Brighter cyan
            : UIColor(red: 0.5, green: 0.75, blue: 0.85, alpha: 1.0)
    })

    let exhaleColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.55, green: 0.85, blue: 0.75, alpha: 1.0)  // Brighter mint
            : UIColor(red: 0.6, green: 0.8, blue: 0.7, alpha: 1.0)
    })
}

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}
