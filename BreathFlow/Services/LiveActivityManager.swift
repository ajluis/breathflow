import ActivityKit
import Foundation

@MainActor
class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()

    private var activity: Activity<BreathingActivityAttributes>?

    private init() {}

    func startActivity(exerciseName: String, exercisePattern: String, totalBreaths: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities not enabled")
            return
        }

        let attributes = BreathingActivityAttributes(
            exerciseName: exerciseName,
            exercisePattern: exercisePattern
        )

        let initialState = BreathingActivityAttributes.ContentState(
            phase: "inhale",
            breathsRemaining: totalBreaths,
            totalBreaths: totalBreaths,
            phaseSecondsRemaining: 5,
            phaseDuration: 5,
            progress: 0.0
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            print("Live Activity started: \(activity?.id ?? "unknown")")
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }

    func updateActivity(phase: String, breathsRemaining: Int, totalBreaths: Int, phaseSecondsRemaining: Int, phaseDuration: Int) {
        let progress = Double(totalBreaths - breathsRemaining) / Double(totalBreaths)

        let updatedState = BreathingActivityAttributes.ContentState(
            phase: phase,
            breathsRemaining: breathsRemaining,
            totalBreaths: totalBreaths,
            phaseSecondsRemaining: phaseSecondsRemaining,
            phaseDuration: phaseDuration,
            progress: progress
        )

        Task {
            await activity?.update(
                ActivityContent(state: updatedState, staleDate: nil)
            )
        }
    }

    func endActivity() {
        Task {
            let finalState = BreathingActivityAttributes.ContentState(
                phase: "complete",
                breathsRemaining: 0,
                totalBreaths: 1,
                phaseSecondsRemaining: 0,
                phaseDuration: 1,
                progress: 1.0
            )

            await activity?.end(
                ActivityContent(state: finalState, staleDate: nil),
                dismissalPolicy: .immediate
            )
            activity = nil
        }
    }
}
