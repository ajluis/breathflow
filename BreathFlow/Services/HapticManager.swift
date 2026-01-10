import CoreHaptics
import UIKit

class HapticManager {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?
    private var continuousPlayer: CHHapticAdvancedPatternPlayer?

    private(set) var isEnabled: Bool = UserDefaults.standard.bool(forKey: "hapticEnabled") {
        didSet { UserDefaults.standard.set(isEnabled, forKey: "hapticEnabled") }
    }

    var intensity: HapticIntensity = HapticIntensity(rawValue: UserDefaults.standard.string(forKey: "hapticIntensity") ?? "medium") ?? .medium {
        didSet { UserDefaults.standard.set(intensity.rawValue, forKey: "hapticIntensity") }
    }

    var pattern: HapticPattern = HapticPattern(rawValue: UserDefaults.standard.string(forKey: "hapticPattern") ?? "gentle") ?? .gentlePulse {
        didSet { UserDefaults.standard.set(pattern.rawValue, forKey: "hapticPattern") }
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

        var hapticIntensity: Float {
            switch self {
            case .light: return 0.4
            case .medium: return 0.7
            case .strong: return 1.0
            }
        }

        var displayName: String {
            rawValue.capitalized
        }
    }

    enum HapticPattern: String, CaseIterable {
        case gentlePulse = "gentle"
        case breathingRhythm = "rhythm"
        case gradualIntensity = "gradual"
        case distinctPatterns = "distinct"

        var displayName: String {
            switch self {
            case .gentlePulse: return "Gentle Pulse"
            case .breathingRhythm: return "Breathing Rhythm"
            case .gradualIntensity: return "Gradual Intensity"
            case .distinctPatterns: return "Distinct Patterns"
            }
        }

        var description: String {
            switch self {
            case .gentlePulse: return "Single tap when each phase starts"
            case .breathingRhythm: return "Subtle pulses throughout breathing"
            case .gradualIntensity: return "Intensity builds and fades with breath"
            case .distinctPatterns: return "Different feels for inhale vs exhale"
            }
        }
    }

    private init() {
        // Default to enabled on first launch
        if UserDefaults.standard.object(forKey: "hapticEnabled") == nil {
            isEnabled = true
            UserDefaults.standard.set(true, forKey: "hapticEnabled")
        }
        setupEngine()
    }

    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            engine?.stoppedHandler = { _ in }
            try engine?.start()
        } catch {
            print("Haptic engine setup failed: \(error)")
        }
    }

    func playInhale() {
        guard isEnabled else { return }

        switch pattern {
        case .gentlePulse:
            playSimpleImpact()
        case .breathingRhythm:
            playRhythmicPulse(count: 3)
        case .gradualIntensity:
            playGradualHaptic(ascending: true)
        case .distinctPatterns:
            playInhalePattern()
        }
    }

    func playExhale() {
        guard isEnabled else { return }

        switch pattern {
        case .gentlePulse:
            playSimpleImpact()
        case .breathingRhythm:
            playRhythmicPulse(count: 3)
        case .gradualIntensity:
            playGradualHaptic(ascending: false)
        case .distinctPatterns:
            playExhalePattern()
        }
    }

    func playCompletion() {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func toggle() {
        isEnabled.toggle()
    }

    // MARK: - Pattern Implementations

    private func playSimpleImpact() {
        let generator = UIImpactFeedbackGenerator(style: intensity.impactStyle)
        generator.impactOccurred()
    }

    private func playRhythmicPulse(count: Int) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                generator.impactOccurred(intensity: CGFloat(self.intensity.hapticIntensity * 0.6))
            }
        }
    }

    private func playGradualHaptic(ascending: Bool) {
        guard let engine = engine else {
            playSimpleImpact()
            return
        }

        do {
            let intensityBase = intensity.hapticIntensity
            var events: [CHHapticEvent] = []

            // Create 4 events with increasing/decreasing intensity
            for i in 0..<4 {
                let progress = Float(i) / 3.0
                let eventIntensity = ascending
                    ? intensityBase * (0.3 + 0.7 * progress)
                    : intensityBase * (1.0 - 0.7 * progress)

                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: eventIntensity),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                    ],
                    relativeTime: Double(i) * 0.12
                )
                events.append(event)
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            playSimpleImpact()
        }
    }

    private func playInhalePattern() {
        guard let engine = engine else {
            playSimpleImpact()
            return
        }

        do {
            let intensityValue = intensity.hapticIntensity

            // Rising pattern - soft continuous with sharp accent
            let events: [CHHapticEvent] = [
                CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue * 0.5),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                    ],
                    relativeTime: 0,
                    duration: 0.3
                ),
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                    ],
                    relativeTime: 0.25
                )
            ]

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            playSimpleImpact()
        }
    }

    private func playExhalePattern() {
        guard let engine = engine else {
            playSimpleImpact()
            return
        }

        do {
            let intensityValue = intensity.hapticIntensity

            // Falling pattern - sharp accent then soft fade
            let events: [CHHapticEvent] = [
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue * 0.7),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                    ],
                    relativeTime: 0
                ),
                CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue * 0.3),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
                    ],
                    relativeTime: 0.05,
                    duration: 0.25
                )
            ]

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            playSimpleImpact()
        }
    }
}
