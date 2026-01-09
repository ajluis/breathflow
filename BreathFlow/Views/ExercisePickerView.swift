import SwiftUI

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedExercise: BreathingExercise = .balanced
    @State private var selectedDuration: SessionDuration = .five
    @State private var showSession = false

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose Exercise")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)

                        ForEach(BreathingExercise.allCases) { exercise in
                            ExerciseCard(
                                exercise: exercise,
                                isSelected: selectedExercise == exercise,
                                action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedExercise = exercise
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Duration")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            ForEach(SessionDuration.allCases) { duration in
                                DurationButton(
                                    duration: duration,
                                    isSelected: selectedDuration == duration,
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedDuration = duration
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer().frame(height: 32)

                    Button(action: {
                        showSession = true
                    }) {
                        Text("Begin")
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
                }
                .padding(.top, 24)
            }
        }
        .navigationTitle("New Session")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showSession) {
            BreathingSessionView(
                exercise: selectedExercise,
                duration: selectedDuration,
                onDismissToHome: {
                    dismiss()
                }
            )
        }
    }
}

struct DurationButton: View {
    let duration: SessionDuration
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(duration.displayName)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : Color.theme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Color.theme.primary : Color.theme.cardBackground)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
