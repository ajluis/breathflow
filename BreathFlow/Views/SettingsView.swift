import SwiftUI

struct SettingsView: View {
    @State private var soundEnabled: Bool = !AudioManager.shared.isMuted
    @State private var soundVolume: Double = UserDefaults.standard.double(forKey: "soundVolume").nonZeroOrDefault(0.7)
    @State private var hapticEnabled: Bool = HapticManager.shared.isEnabled
    @State private var hapticIntensity: HapticManager.HapticIntensity = HapticManager.shared.intensity

    var body: some View {
        List {
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
            Section("Haptics") {
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
                        HapticManager.shared.playInhale()
                    }
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
    }
}
