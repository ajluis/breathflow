import Foundation

class StatsManager: ObservableObject {
    static let shared = StatsManager()

    private let statsKey = "breathflow_user_stats"
    private let calendar = Calendar.current

    @Published var stats: UserStats {
        didSet {
            save()
        }
    }

    private init() {
        self.stats = StatsManager.load()
    }

    private static func load() -> UserStats {
        guard let data = UserDefaults.standard.data(forKey: "breathflow_user_stats"),
              let stats = try? JSONDecoder().decode(UserStats.self, from: data) else {
            return UserStats()
        }
        return stats
    }

    private func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: statsKey)
        }
    }

    func completeSession(durationSeconds: Int) {
        stats.totalSecondsBreathed += durationSeconds
        updateStreak()
    }

    private func updateStreak() {
        let today = calendar.startOfDay(for: Date())

        guard let lastDate = stats.lastSessionDate else {
            stats.currentStreak = 1
            stats.lastSessionDate = today
            return
        }

        let lastSessionDay = calendar.startOfDay(for: lastDate)

        if calendar.isDate(lastSessionDay, inSameDayAs: today) {
            stats.lastSessionDate = today
            return
        }

        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
           calendar.isDate(lastSessionDay, inSameDayAs: yesterday) {
            stats.currentStreak += 1
        } else {
            stats.currentStreak = 1
        }

        stats.lastSessionDate = today
    }

    func resetStats() {
        stats = UserStats()
    }
}
