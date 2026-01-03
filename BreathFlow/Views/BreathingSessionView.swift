import SwiftUI

enum SessionState {
    case countdown
    case breathing
    case completed
}

struct BreathingSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    let exercise: BreathingExercise
    let duration: SessionDuration

    @State private var sessionState: SessionState = .countdown
    @State private var countdownValue: Int = 3
    @State private var phase: BreathPhase = .inhale
    @State private var phaseProgress: Double = 0
    @State private var phaseSecondsRemaining: Int = 0
    @State private var breathsRemaining: Int = 0
    @State private var totalBreaths: Int = 0
    @State private var isPaused = false
    @State private var showCompletion = false
    @State private var timer: Timer?
    @State private var phaseDuration: Double = 0
    @State private var phaseStartTime: Date?

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: phase)
                .animation(.easeInOut(duration: 0.3), value: sessionState)

            if sessionState == .countdown {
                countdownView
            } else {
                breathingView
            }
        }
        .onAppear {
            calculateTotalBreaths()
            startCountdown()
        }
        .onDisappear {
            stopSession()
        }
        .onChange(of: scenePhase) { newPhase in
            handleScenePhaseChange(newPhase)
        }
        .fullScreenCover(isPresented: $showCompletion) {
            CompletionView(
                exercise: exercise,
                duration: duration
            )
        }
    }

    private var backgroundColor: Color {
        switch sessionState {
        case .countdown:
            return Color.theme.primary.opacity(0.15)
        case .breathing, .completed:
            return phase.color.opacity(0.15)
        }
    }

    private var countdownView: some View {
        VStack(spacing: 24) {
            Text("Get Ready")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.textPrimary)

            Text("\(countdownValue)")
                .font(.system(size: 120, weight: .light, design: .rounded))
                .foregroundColor(Color.theme.primary)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: countdownValue)

            Text("First breath: Inhale")
                .font(.headline)
                .foregroundColor(Color.theme.textSecondary)
        }
    }

    private var breathingView: some View {
        VStack(spacing: 40) {
            HStack {
                Button(action: {
                    stopSession()
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(Color.theme.textSecondary)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(breathsRemaining)")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.theme.textPrimary)
                    Text("breaths left")
                        .font(.caption)
                        .foregroundColor(Color.theme.textSecondary)
                }

                Spacer()

                Button(action: {
                    isPaused.toggle()
                    if isPaused {
                        pauseSession()
                    } else {
                        resumeSession()
                    }
                }) {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .foregroundColor(Color.theme.textSecondary)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 24) {
                BreathingCircle(
                    phase: phase,
                    progress: phaseProgress,
                    secondsRemaining: phaseSecondsRemaining,
                    isPaused: isPaused
                )

                if isPaused {
                    Text("When you resume, it will start on inhale")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                Text(exercise.displayName)
                    .font(.headline)
                    .foregroundColor(Color.theme.textSecondary)

                Text(exercise.pattern)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textSecondary.opacity(0.7))
            }
            .padding(.bottom, 48)
        }
    }

    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            if sessionState == .breathing && !isPaused {
                AudioManager.shared.startBackgroundAudio()
            }
        case .active:
            AudioManager.shared.stopBackgroundAudio()
        default:
            break
        }
    }

    private func calculateTotalBreaths() {
        let cycleDuration = exercise.inhaleSeconds + exercise.exhaleSeconds
        totalBreaths = Int(Double(duration.totalSeconds) / cycleDuration)
        breathsRemaining = totalBreaths
    }

    private func startCountdown() {
        countdownValue = 3
        sessionState = .countdown

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdownValue > 1 {
                countdownValue -= 1
            } else {
                timer?.invalidate()
                timer = nil
                startBreathing()
            }
        }
    }

    private func startBreathing() {
        sessionState = .breathing
        startPhase(.inhale)
    }

    private func startPhase(_ newPhase: BreathPhase) {
        phase = newPhase
        phaseDuration = newPhase == .inhale ? exercise.inhaleSeconds : exercise.exhaleSeconds
        phaseSecondsRemaining = Int(phaseDuration)
        phaseStartTime = Date()

        // Reset progress without animation
        phaseProgress = 0

        // Play audio
        if newPhase == .inhale {
            AudioManager.shared.playInhaleTone()
        } else {
            AudioManager.shared.playExhaleTone()
        }

        // Animate progress to 1.0 over the full phase duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation(.linear(duration: phaseDuration)) {
                phaseProgress = 1.0
            }
        }

        // Timer for countdown display and phase switching
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateCountdown()
        }
    }

    private func updateCountdown() {
        guard let startTime = phaseStartTime else { return }

        let elapsed = Date().timeIntervalSince(startTime)
        let remaining = max(0, phaseDuration - elapsed)
        phaseSecondsRemaining = Int(ceil(remaining))

        if elapsed >= phaseDuration {
            switchPhase()
        }
    }

    private func pauseSession() {
        timer?.invalidate()
        timer = nil

        // Cancel animation by resetting progress immediately
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            phaseProgress = 0
        }

        AudioManager.shared.stopBackgroundAudio()
    }

    private func resumeSession() {
        // Resume always starts fresh with an inhale, keeping breath count
        startPhase(.inhale)
    }

    private func stopSession() {
        timer?.invalidate()
        timer = nil
        AudioManager.shared.stopBackgroundAudio()
    }

    private func switchPhase() {
        timer?.invalidate()
        timer = nil

        if phase == .inhale {
            startPhase(.exhale)
        } else {
            breathsRemaining -= 1

            if breathsRemaining <= 0 {
                completeSession()
                return
            }

            startPhase(.inhale)
        }
    }

    private func completeSession() {
        stopSession()
        sessionState = .completed
        StatsManager.shared.completeSession(durationSeconds: duration.totalSeconds)
        AudioManager.shared.playCompletionSound()
        showCompletion = true
    }
}
