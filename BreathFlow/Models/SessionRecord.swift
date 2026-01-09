import Foundation

struct SessionRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let exerciseType: String
    let exerciseName: String
    let durationSeconds: Int
    let breathCount: Int

    init(id: UUID = UUID(), date: Date = Date(), exercise: BreathingExercise, durationSeconds: Int, breathCount: Int) {
        self.id = id
        self.date = date
        self.exerciseType = exercise.rawValue
        self.exerciseName = exercise.displayName
        self.durationSeconds = durationSeconds
        self.breathCount = breathCount
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var formattedDuration: String {
        let minutes = durationSeconds / 60
        return "\(minutes) min"
    }
}
