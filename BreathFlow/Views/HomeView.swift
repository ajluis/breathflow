import SwiftUI

struct HomeView: View {
    @ObservedObject var statsManager = StatsManager.shared
    @State private var showExercisePicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    VStack(spacing: 8) {
                        Text("BreathFlow")
                            .font(.system(size: 36, weight: .light, design: .rounded))
                            .foregroundColor(Color.theme.textPrimary)

                        Text("Find your calm")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.textSecondary)
                    }

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
                    .padding(.horizontal)

                    Spacer()

                    Button(action: {
                        showExercisePicker = true
                    }) {
                        Text("Start Session")
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
                }
            }
            .navigationDestination(isPresented: $showExercisePicker) {
                ExercisePickerView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color.theme.textSecondary)
                    }
                }
            }
        }
    }
}
