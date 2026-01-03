import Foundation

enum BreathingExercise: String, CaseIterable, Identifiable {
    case balanced
    case relaxing

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .balanced: return "Balanced"
        case .relaxing: return "Relaxing"
        }
    }

    var description: String {
        switch self {
        case .balanced: return "Equal breathing for focus and calm"
        case .relaxing: return "Extended exhale for deep relaxation"
        }
    }

    var pattern: String {
        switch self {
        case .balanced: return "5 in / 5 out"
        case .relaxing: return "4 in / 8 out"
        }
    }

    var inhaleSeconds: Double {
        switch self {
        case .balanced: return 5.0
        case .relaxing: return 4.0
        }
    }

    var exhaleSeconds: Double {
        switch self {
        case .balanced: return 5.0
        case .relaxing: return 8.0
        }
    }

    var cycleDuration: Double {
        inhaleSeconds + exhaleSeconds
    }
}

enum SessionDuration: Int, CaseIterable, Identifiable {
    case five = 5
    case ten = 10
    case fifteen = 15
    case twenty = 20

    var id: Int { rawValue }

    var displayName: String {
        "\(rawValue) min"
    }

    var totalSeconds: Int {
        rawValue * 60
    }
}
