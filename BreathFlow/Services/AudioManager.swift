import AVFoundation
import Foundation

class AudioManager {
    static let shared = AudioManager()

    private var inhalePlayer: AVAudioPlayer?
    private var exhalePlayer: AVAudioPlayer?
    private var silentPlayer: AVAudioPlayer?

    private var isSessionActive = false
    private(set) var isMuted: Bool = UserDefaults.standard.bool(forKey: "audioMuted")

    private init() {
        setupAudioSession()
        loadAudioFiles()
    }

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleInterruption),
                name: AVAudioSession.interruptionNotification,
                object: session
            )
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    private func loadAudioFiles() {
        if let inhaleURL = Bundle.main.url(forResource: "inhale", withExtension: "mp3") {
            do {
                inhalePlayer = try AVAudioPlayer(contentsOf: inhaleURL)
                inhalePlayer?.volume = 0.7
                inhalePlayer?.prepareToPlay()
            } catch {
                print("Failed to load inhale sound: \(error)")
            }
        }

        if let exhaleURL = Bundle.main.url(forResource: "exhale", withExtension: "mp3") {
            do {
                exhalePlayer = try AVAudioPlayer(contentsOf: exhaleURL)
                exhalePlayer?.volume = 0.7
                exhalePlayer?.prepareToPlay()
            } catch {
                print("Failed to load exhale sound: \(error)")
            }
        }
    }

    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            stopBackgroundAudio()
        case .ended:
            if isSessionActive {
                startBackgroundAudio()
            }
        @unknown default:
            break
        }
    }

    func startBackgroundAudio() {
        isSessionActive = true
        playSilentAudio()
    }

    func stopBackgroundAudio() {
        isSessionActive = false
        silentPlayer?.stop()
    }

    private func playSilentAudio() {
        // Create a silent audio file or use a very quiet loop to keep audio session active
        // We'll use a data URL with minimal silent audio
        let silentData = createSilentAudioData()
        do {
            silentPlayer = try AVAudioPlayer(data: silentData)
            silentPlayer?.numberOfLoops = -1 // Loop indefinitely
            silentPlayer?.volume = 0.01
            silentPlayer?.play()
        } catch {
            print("Failed to play silent audio: \(error)")
        }
    }

    private func createSilentAudioData() -> Data {
        // Create a minimal WAV file with silence
        let sampleRate: UInt32 = 44100
        let duration: Double = 1.0
        let numSamples = Int(Double(sampleRate) * duration)

        var data = Data()

        // WAV header
        data.append(contentsOf: "RIFF".utf8)
        let fileSize = UInt32(36 + numSamples * 2)
        data.append(contentsOf: withUnsafeBytes(of: fileSize.littleEndian) { Array($0) })
        data.append(contentsOf: "WAVE".utf8)

        // fmt chunk
        data.append(contentsOf: "fmt ".utf8)
        data.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) }) // PCM
        data.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) }) // Mono
        data.append(contentsOf: withUnsafeBytes(of: sampleRate.littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: (sampleRate * 2).littleEndian) { Array($0) }) // Byte rate
        data.append(contentsOf: withUnsafeBytes(of: UInt16(2).littleEndian) { Array($0) }) // Block align
        data.append(contentsOf: withUnsafeBytes(of: UInt16(16).littleEndian) { Array($0) }) // Bits per sample

        // data chunk
        data.append(contentsOf: "data".utf8)
        data.append(contentsOf: withUnsafeBytes(of: UInt32(numSamples * 2).littleEndian) { Array($0) })

        // Silent samples
        for _ in 0..<numSamples {
            data.append(contentsOf: withUnsafeBytes(of: Int16(0).littleEndian) { Array($0) })
        }

        return data
    }

    func toggleMute() {
        isMuted.toggle()
        UserDefaults.standard.set(isMuted, forKey: "audioMuted")
    }

    func playInhaleTone() {
        guard !isMuted else { return }
        inhalePlayer?.currentTime = 0
        inhalePlayer?.play()
    }

    func playExhaleTone() {
        guard !isMuted else { return }
        exhalePlayer?.currentTime = 0
        exhalePlayer?.play()
    }

    func playCompletionSound() {
        // Play a simple completion sequence using inhale sound
        inhalePlayer?.currentTime = 0
        inhalePlayer?.play()
    }
}
