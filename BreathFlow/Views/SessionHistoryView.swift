import SwiftUI

struct SessionHistoryView: View {
    @ObservedObject var historyManager = SessionHistoryManager.shared

    var body: some View {
        Group {
            if historyManager.sessions.isEmpty {
                emptyStateView
            } else {
                sessionListView
            }
        }
        .navigationTitle("History")
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.textSecondary.opacity(0.5))

            Text("No Sessions Yet")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.textPrimary)

            Text("Complete your first breathing session\nto see it here")
                .font(.subheadline)
                .foregroundColor(Color.theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background)
    }

    private var sessionListView: some View {
        List {
            ForEach(historyManager.sessionsByDate, id: \.date) { group in
                Section(header: Text(group.date)) {
                    ForEach(group.sessions) { session in
                        SessionRowView(session: session)
                    }
                    .onDelete { indexSet in
                        deleteSession(from: group.sessions, at: indexSet)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func deleteSession(from sessions: [SessionRecord], at indexSet: IndexSet) {
        for index in indexSet {
            let session = sessions[index]
            historyManager.deleteSession(id: session.id)
        }
    }
}

struct SessionRowView: View {
    let session: SessionRecord

    var body: some View {
        HStack(spacing: 12) {
            // Exercise type icon
            ZStack {
                Circle()
                    .fill(exerciseColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: "wind")
                    .font(.system(size: 18))
                    .foregroundColor(exerciseColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(session.exerciseName)
                    .font(.headline)
                    .foregroundColor(Color.theme.textPrimary)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(session.formattedDuration)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "lungs")
                        Text("\(session.breathCount) breaths")
                    }
                }
                .font(.caption)
                .foregroundColor(Color.theme.textSecondary)
            }

            Spacer()

            Text(session.formattedTime)
                .font(.subheadline)
                .foregroundColor(Color.theme.textSecondary)
        }
        .padding(.vertical, 4)
    }

    private var exerciseColor: Color {
        session.exerciseType == "balanced" ? Color.theme.inhaleColor : Color.theme.exhaleColor
    }
}

#Preview {
    NavigationStack {
        SessionHistoryView()
    }
}
