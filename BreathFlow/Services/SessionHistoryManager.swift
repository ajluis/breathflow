import Foundation

class SessionHistoryManager: ObservableObject {
    static let shared = SessionHistoryManager()

    private let sessionsKey = "breathflow_session_history"

    @Published private(set) var sessions: [SessionRecord] = []

    private init() {
        load()
    }

    func addSession(exercise: BreathingExercise, durationSeconds: Int, breathCount: Int) {
        let record = SessionRecord(
            exercise: exercise,
            durationSeconds: durationSeconds,
            breathCount: breathCount
        )
        sessions.insert(record, at: 0)
        save()
    }

    func deleteSession(id: UUID) {
        sessions.removeAll { $0.id == id }
        save()
    }

    func getSessionsForDate(_ date: Date) -> [SessionRecord] {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func hasSessionToday() -> Bool {
        let today = Date()
        return !getSessionsForDate(today).isEmpty
    }

    /// Group sessions by date for display
    var sessionsByDate: [(date: String, sessions: [SessionRecord])] {
        let grouped = Dictionary(grouping: sessions) { record in
            record.formattedDate
        }

        return grouped
            .map { (date: $0.key, sessions: $0.value) }
            .sorted { first, second in
                guard let firstDate = first.sessions.first?.date,
                      let secondDate = second.sessions.first?.date else {
                    return false
                }
                return firstDate > secondDate
            }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) else {
            sessions = []
            return
        }
        sessions = decoded
    }
}
