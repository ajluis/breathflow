import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    private let themeKey = "app_theme"

    @Published var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch theme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: themeKey) ?? "system"
        self.theme = AppTheme(rawValue: saved) ?? .system
    }
}
