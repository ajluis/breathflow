import ActivityKit
import Foundation

struct BreathingActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var phase: String
        var breathsRemaining: Int
        var totalBreaths: Int
        var phaseSecondsRemaining: Int
        var phaseDuration: Int
        var progress: Double

        var progressPercentage: Double {
            let completed = totalBreaths - breathsRemaining
            return Double(completed) / Double(totalBreaths)
        }

        /// Fill amount for the breathing bar (0-1)
        /// Fills up during inhale, empties during exhale
        var phaseFillAmount: Double {
            guard phaseDuration > 0 else { return 0 }
            let elapsed = Double(phaseDuration - phaseSecondsRemaining)
            let fillProgress = elapsed / Double(phaseDuration)

            if phase == "inhale" {
                return min(1.0, fillProgress)
            } else {
                return max(0.0, 1.0 - fillProgress)
            }
        }
    }

    var exerciseName: String
    var exercisePattern: String
}
