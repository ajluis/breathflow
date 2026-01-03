import Foundation

struct UserStats: Codable {
    var totalSecondsBreathed: Int
    var lastSessionDate: Date?
    var currentStreak: Int

    init(totalSecondsBreathed: Int = 0, lastSessionDate: Date? = nil, currentStreak: Int = 0) {
        self.totalSecondsBreathed = totalSecondsBreathed
        self.lastSessionDate = lastSessionDate
        self.currentStreak = currentStreak
    }

    var formattedTotalTime: String {
        let hours = totalSecondsBreathed / 3600
        let minutes = (totalSecondsBreathed % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes) min"
        } else {
            return "0 min"
        }
    }
}
