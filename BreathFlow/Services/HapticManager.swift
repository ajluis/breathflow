import CoreHaptics
import UIKit

class HapticManager {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?
    private(set) var isEnabled: Bool = UserDefaults.standard.bool(forKey: "hapticEnabled") {
        didSet { UserDefaults.standard.set(isEnabled, forKey: "hapticEnabled") }
    }
    var intensity: HapticIntensity = HapticIntensity(rawValue: UserDefaults.standard.string(forKey: "hapticIntensity") ?? "medium") ?? .medium {
        didSet { UserDefaults.standard.set(intensity.rawValue, forKey: "hapticIntensity") }
    }

    enum HapticIntensity: String, CaseIterable {
        case light, medium, strong

        var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .strong: return .heavy
            }
        }

        var displayName: String {
            rawValue.capitalized
        }
    }

    private init() {
        // Default to enabled on first launch
        if UserDefaults.standard.object(forKey: "hapticEnabled") == nil {
            isEnabled = true
            UserDefaults.standard.set(true, forKey: "hapticEnabled")
        }
    }

    func playInhale() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: intensity.impactStyle)
        generator.impactOccurred()
    }

    func playExhale() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: intensity.impactStyle)
        generator.impactOccurred()
    }

    func playCompletion() {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func toggle() {
        isEnabled.toggle()
    }
}
