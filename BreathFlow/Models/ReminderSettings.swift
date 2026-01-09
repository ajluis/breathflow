import Foundation

struct ReminderSettings: Codable {
    var isEnabled: Bool
    var hour: Int
    var minute: Int
    var isSmartReminder: Bool

    init(isEnabled: Bool = false, hour: Int = 9, minute: Int = 0, isSmartReminder: Bool = true) {
        self.isEnabled = isEnabled
        self.hour = hour
        self.minute = minute
        self.isSmartReminder = isSmartReminder
    }

    var reminderTime: Date {
        get {
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            hour = components.hour ?? 9
            minute = components.minute ?? 0
        }
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: reminderTime)
    }
}
