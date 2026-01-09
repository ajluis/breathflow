import HealthKit
import Foundation

class HealthKitManager {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()
    private let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!

    var isAuthorized: Bool {
        healthStore.authorizationStatus(for: mindfulType) == .sharingAuthorized
    }

    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard isHealthKitAvailable else {
            completion(false)
            return
        }

        let typesToWrite: Set<HKSampleType> = [mindfulType]

        healthStore.requestAuthorization(toShare: typesToWrite, read: nil) { success, error in
            DispatchQueue.main.async {
                completion(success && error == nil)
            }
        }
    }

    func saveMindfulSession(
        startDate: Date,
        endDate: Date,
        exerciseName: String
    ) {
        guard isAuthorized else { return }

        let metadata: [String: Any] = [
            HKMetadataKeyWorkoutBrandName: "BreathFlow",
            "ExerciseType": exerciseName
        ]

        let sample = HKCategorySample(
            type: mindfulType,
            value: HKCategoryValue.notApplicable.rawValue,
            start: startDate,
            end: endDate,
            metadata: metadata
        )

        healthStore.save(sample) { success, error in
            if let error = error {
                print("HealthKit save error: \(error.localizedDescription)")
            }
        }
    }
}
