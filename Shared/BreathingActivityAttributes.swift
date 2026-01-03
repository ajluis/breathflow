import ActivityKit
import Foundation

struct BreathingActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var phase: String
        var breathsRemaining: Int
        var totalBreaths: Int
        var phaseSecondsRemaining: Int
        var progress: Double

        var progressPercentage: Double {
            let completed = totalBreaths - breathsRemaining
            return Double(completed) / Double(totalBreaths)
        }
    }

    var exerciseName: String
    var exercisePattern: String
}
