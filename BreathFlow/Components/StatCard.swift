import SwiftUI

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    var iconColor: Color = Color.theme.primary

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(iconColor)

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color.theme.textPrimary)

            Text(title)
                .font(.subheadline)
                .foregroundColor(Color.theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
}

struct ExerciseCard: View {
    let exercise: BreathingExercise
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(exercise.displayName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.textPrimary)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.theme.primary)
                            .font(.title2)
                    }
                }

                Text(exercise.pattern)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(Color.theme.primary)

                Text(exercise.description)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textSecondary)
                    .lineLimit(2)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.theme.primary.opacity(0.1) : Color.theme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.theme.primary : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
