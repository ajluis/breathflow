import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var statsManager = StatsManager.shared

    let exercise: BreathingExercise
    let duration: SessionDuration

    @State private var showContent = false

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
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)

                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        StatCard(
                            icon: "flame.fill",
                            title: "Day Streak",
                            value: "\(statsManager.stats.currentStreak)",
                            iconColor: Color.theme.streakColor
                        )

                        StatCard(
                            icon: "clock.fill",
                            title: "Total Time",
                            value: statsManager.stats.formattedTotalTime
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
        }
    }
}
