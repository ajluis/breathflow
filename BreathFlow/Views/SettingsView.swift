import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appSettings: AppSettings

    @State private var soundEnabled: Bool = !AudioManager.shared.isMuted
    @State private var soundVolume: Double = UserDefaults.standard.double(forKey: "soundVolume").nonZeroOrDefault(0.7)
    @State private var hapticEnabled: Bool = HapticManager.shared.isEnabled
    @State private var hapticIntensity: HapticManager.HapticIntensity = HapticManager.shared.intensity
    @State private var hapticPattern: HapticManager.HapticPattern = HapticManager.shared.pattern

    @ObservedObject private var notificationManager = NotificationManager.shared
    @State private var reminderTime: Date = NotificationManager.shared.settings.reminderTime

    var body: some View {
        List {
            // Appearance Settings
            Section("Appearance") {
                Picker("Theme", selection: $appSettings.theme) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Label(theme.displayName, systemImage: theme.icon)
                            .tag(theme)
                    }
                }
            }

            // Sound Settings
            Section("Sound") {
                Toggle("Sound Effects", isOn: $soundEnabled)
                    .onChange(of: soundEnabled) { newValue in
                        if AudioManager.shared.isMuted == newValue {
                            AudioManager.shared.toggleMute()
                        }
                    }

                if soundEnabled {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Volume")
                            .font(.subheadline)
                        Slider(value: $soundVolume, in: 0.1...1.0, step: 0.1)
                            .onChange(of: soundVolume) { newValue in
                                AudioManager.shared.setVolume(newValue)
                            }
                    }

                    Button("Test Sound") {
                        AudioManager.shared.playInhaleTone()
                    }
                }
            }

            // Haptic Settings
            Section {
                Toggle("Haptic Feedback", isOn: $hapticEnabled)
                    .onChange(of: hapticEnabled) { _ in
                        HapticManager.shared.toggle()
                    }

                if hapticEnabled {
                    Picker("Intensity", selection: $hapticIntensity) {
                        ForEach(HapticManager.HapticIntensity.allCases, id: \.self) { intensity in
                            Text(intensity.displayName).tag(intensity)
                        }
                    }
                    .onChange(of: hapticIntensity) { newValue in
                        HapticManager.shared.intensity = newValue
                    }

                    Picker("Pattern", selection: $hapticPattern) {
                        ForEach(HapticManager.HapticPattern.allCases, id: \.self) { pattern in
                            Text(pattern.displayName).tag(pattern)
                        }
                    }
                    .onChange(of: hapticPattern) { newValue in
                        HapticManager.shared.pattern = newValue
                        HapticManager.shared.playInhale()
                    }

                    Button("Test Haptic") {
                        HapticManager.shared.playInhale()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            HapticManager.shared.playExhale()
                        }
                    }
                }
            } header: {
                Text("Haptics")
            } footer: {
                if hapticEnabled {
                    Text(hapticPattern.description)
                }
            }

            // Reminders
            Section {
                Toggle("Daily Reminder", isOn: Binding(
                    get: { notificationManager.settings.isEnabled },
                    set: { newValue in
                        notificationManager.settings.isEnabled = newValue
                        if newValue {
                            notificationManager.requestAuthorization { granted in
                                if granted {
                                    notificationManager.scheduleReminder()
                                } else {
                                    notificationManager.settings.isEnabled = false
                                }
                            }
                        } else {
                            notificationManager.cancelReminder()
                        }
                    }
                ))

                if notificationManager.settings.isEnabled {
                    DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .onChange(of: reminderTime) { newValue in
                            notificationManager.settings.reminderTime = newValue
                            notificationManager.scheduleReminder()
                        }

                    Toggle("Smart Reminder", isOn: Binding(
                        get: { notificationManager.settings.isSmartReminder },
                        set: { newValue in
                            notificationManager.settings.isSmartReminder = newValue
                        }
                    ))
                }
            } header: {
                Text("Reminders")
            } footer: {
                if notificationManager.settings.isEnabled && notificationManager.settings.isSmartReminder {
                    Text("Smart reminder will only notify you if you haven't practiced today.")
                }
            }

            // Health Integration
            Section("Health") {
                NavigationLink(destination: HealthSettingsView()) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Apple Health")
                    }
                }
            }

            // About
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct HealthSettingsView: View {
    @State private var healthEnabled = HealthKitManager.shared.isAuthorized
    @State private var isRequesting = false

    var body: some View {
        List {
            Section {
                if HealthKitManager.shared.isHealthKitAvailable {
                    Toggle("Sync to Apple Health", isOn: $healthEnabled)
                        .disabled(isRequesting)
                        .onChange(of: healthEnabled) { newValue in
                            if newValue && !HealthKitManager.shared.isAuthorized {
                                isRequesting = true
                                HealthKitManager.shared.requestAuthorization { success in
                                    isRequesting = false
                                    healthEnabled = success
                                }
                            }
                        }
                } else {
                    Text("HealthKit is not available on this device")
                        .foregroundColor(.secondary)
                }
            } footer: {
                Text("When enabled, completed breathing sessions are saved as Mindful Minutes in the Health app.")
            }
        }
        .navigationTitle("Apple Health")
        .onAppear {
            healthEnabled = HealthKitManager.shared.isAuthorized
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppSettings.shared)
    }
}
