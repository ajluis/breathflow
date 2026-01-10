import SwiftUI

@main
struct BreathFlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appSettings = AppSettings.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appSettings)
                .preferredColorScheme(appSettings.preferredColorScheme)
        }
    }
}
