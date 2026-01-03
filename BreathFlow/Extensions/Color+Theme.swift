import SwiftUI

extension Color {
    static let theme = ThemeColors()
}

struct ThemeColors {
    let primary = Color(red: 0.4, green: 0.7, blue: 0.8)
    let primaryDark = Color(red: 0.3, green: 0.5, blue: 0.6)
    let secondary = Color(red: 0.6, green: 0.8, blue: 0.7)

    let background = Color(red: 0.95, green: 0.97, blue: 0.98)
    let backgroundDark = Color(red: 0.1, green: 0.12, blue: 0.15)

    let cardBackground = Color.white
    let cardBackgroundDark = Color(red: 0.15, green: 0.17, blue: 0.2)

    let textPrimary = Color(red: 0.2, green: 0.25, blue: 0.3)
    let textSecondary = Color(red: 0.5, green: 0.55, blue: 0.6)

    let accent = Color(red: 0.95, green: 0.6, blue: 0.4)
    let streakColor = Color(red: 1.0, green: 0.6, blue: 0.2)

    let inhaleColor = Color(red: 0.5, green: 0.75, blue: 0.85)
    let exhaleColor = Color(red: 0.6, green: 0.8, blue: 0.7)
}

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}
