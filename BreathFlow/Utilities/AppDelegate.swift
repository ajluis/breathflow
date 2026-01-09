import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // Check if this is a smart reminder
        let userInfo = notification.request.content.userInfo
        let isSmartReminder = userInfo["isSmartReminder"] as? Bool ?? false

        if isSmartReminder {
            // Check if user has already practiced today
            if SessionHistoryManager.shared.hasSessionToday() {
                // Suppress notification - user already practiced
                completionHandler([])
                return
            }
        }

        // Show the notification
        completionHandler([.banner, .sound, .badge])
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
        // Clear badge when user taps notification
        NotificationManager.shared.clearBadge()
        completionHandler()
    }
}
