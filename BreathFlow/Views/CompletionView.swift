import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var statsManager = StatsManager.shared

    let exercise: BreathingExercise
    let duration: SessionDuration
    let previousStreak: Int
    let previousTotalSeconds: Int
    var onDismissToHome: (() -> Void)?

    @State private var showContent = false
    @State private var quote = AffirmationQuotes.random()
    @State private var displayedStreak: Int
    @State private var displayedTotalSeconds: Int
    @State private var hasAnimated = false

    init(exercise: BreathingExercise, duration: SessionDuration, previousStreak: Int, previousTotalSeconds: Int, onDismissToHome: (() -> Void)? = nil) {
        self.exercise = exercise
        self.duration = duration
        self.previousStreak = previousStreak
        self.previousTotalSeconds = previousTotalSeconds
        self.onDismissToHome = onDismissToHome
        self._displayedStreak = State(initialValue: previousStreak)
        self._displayedTotalSeconds = State(initialValue: previousTotalSeconds)
    }

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color.theme.secondary)
                        .scaleEffect(showContent ? 1.0 : 0.5)
                        .opacity(showContent ? 1.0 : 0.0)

                    Text("Well Done!")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.theme.textPrimary)
                        .opacity(showContent ? 1.0 : 0.0)

                    Text("You completed a \(duration.rawValue) minute session")
                        .font(.body)
                        .foregroundColor(Color.theme.textSecondary)
                        .opacity(showContent ? 1.0 : 0.0)

                    Text("\"\(quote)\"")
                        .font(.body)
                        .italic()
                        .foregroundColor(Color.theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                        .opacity(showContent ? 1.0 : 0.0)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)

                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        StatCard(
                            icon: "flame.fill",
                            title: "Day Streak",
                            value: "\(displayedStreak)",
                            iconColor: Color.theme.streakColor
                        )

                        StatCard(
                            icon: "clock.fill",
                            title: "Total Time",
                            value: formattedTime(displayedTotalSeconds)
                        )
                    }
                }
                .padding(.horizontal)
                .opacity(showContent ? 1.0 : 0.0)
                .offset(y: showContent ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showContent)

                Spacer()

                Button(action: {
                    dismiss()
                    onDismissToHome?()
                }) {
                    Text("Done")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.theme.primary, Color.theme.primaryDark]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.theme.primary.opacity(0.4), radius: 10, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: showContent)
            }
        }
        .onAppear {
            showContent = true
            animateStats()
        }
    }

    private func animateStats() {
        guard !hasAnimated else { return }
        hasAnimated = true

        // Delay before starting the count-up animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // Animate streak
            let targetStreak = statsManager.stats.currentStreak
            let targetSeconds = statsManager.stats.totalSecondsBreathed

            // Animate over ~1 second with steps
            let steps = 20
            let streakDiff = targetStreak - displayedStreak
            let secondsDiff = targetSeconds - displayedTotalSeconds

            for i in 1...steps {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                    let progress = Double(i) / Double(steps)
                    let easedProgress = easeOutCubic(progress)

                    displayedStreak = previousStreak + Int(Double(streakDiff) * easedProgress)
                    displayedTotalSeconds = previousTotalSeconds + Int(Double(secondsDiff) * easedProgress)
                }
            }
        }
    }

    private func easeOutCubic(_ t: Double) -> Double {
        return 1 - pow(1 - t, 3)
    }

    private func formattedTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
