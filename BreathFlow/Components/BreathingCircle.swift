import SwiftUI

enum BreathPhase {
    case inhale
    case exhale

    var label: String {
        switch self {
        case .inhale: return "Inhale"
        case .exhale: return "Exhale"
        }
    }

    var color: Color {
        switch self {
        case .inhale: return Color.theme.inhaleColor
        case .exhale: return Color.theme.exhaleColor
        }
    }
}

struct BreathingCircle: View {
    let phase: BreathPhase
    let progress: Double
    let secondsRemaining: Int
    var isPaused: Bool = false

    private let circleSize: CGFloat = 280
    private let lineWidth: CGFloat = 12

    private var fillProgress: Double {
        switch phase {
        case .inhale:
            return progress
        case .exhale:
            return 1.0 - progress
        }
    }

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(
                    phase.color.opacity(0.2),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)

            // Progress arc
            Circle()
                .trim(from: 0, to: fillProgress)
                .stroke(
                    phase.color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .shadow(color: phase.color.opacity(0.5), radius: 8, x: 0, y: 0)

            // Inner glow circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            phase.color.opacity(0.12),
                            phase.color.opacity(0.04),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: circleSize / 2 - lineWidth
                    )
                )
                .frame(width: circleSize - lineWidth * 2, height: circleSize - lineWidth * 2)

            // Center content
            VStack(spacing: 12) {
                if isPaused {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 64, weight: .ultraLight))
                        .foregroundColor(Color.theme.textSecondary)
                } else {
                    Text(phase.label)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(phase.color)

                    Text("\(secondsRemaining)")
                        .font(.system(size: 64, weight: .ultraLight, design: .rounded))
                        .foregroundColor(Color.theme.textPrimary)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.3), value: secondsRemaining)
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: phase)
        .animation(.easeInOut(duration: 0.3), value: isPaused)
    }
}
