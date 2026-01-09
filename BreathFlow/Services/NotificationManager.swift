import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    private let settingsKey = "breathflow_reminder_settings"
    private let reminderIdentifier = "breathflow_daily_reminder"

    @Published var settings: ReminderSettings {
        didSet { save() }
    }

    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private init() {
        settings = Self.loadSettings()
        checkAuthorizationStatus()
    }

    private static func loadSettings() -> ReminderSettings {
        guard let data = UserDefaults.standard.data(forKey: "breathflow_reminder_settings"),
              let decoded = try? JSONDecoder().decode(ReminderSettings.self, from: data) else {
            return ReminderSettings()
        }
        return decoded
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.checkAuthorizationStatus()
                completion(granted && error == nil)
            }
        }
    }

    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }

    func scheduleReminder() {
        // Cancel existing reminder first
        cancelReminder()

        guard settings.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time to Breathe"
        content.body = "Take a moment for your daily breathing practice"
        content.sound = .default
        content.badge = 1
        content.userInfo = ["isSmartReminder": settings.isSmartReminder]

        var dateComponents = DateComponents()
        dateComponents.hour = settings.hour
        dateComponents.minute = settings.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
    }

    func updateReminder() {
        if settings.isEnabled {
            scheduleReminder()
        } else {
            cancelReminder()
        }
    }

    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }
}
