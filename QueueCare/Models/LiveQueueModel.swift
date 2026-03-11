import Foundation

struct LiveQueueModel {
    let departmentName: String
    let queueNumber: String      // e.g. "A - 24"
    let currentServing: String   // e.g. "A - 17"
    let peopleAhead: Int
    let estimatedWaitMin: Int

    var estimatedWaitLabel: String {
        "Estimated wait: \(estimatedWaitMin) min"
    }

    static func mock(for departmentName: String) -> LiveQueueModel {
        LiveQueueModel(
            departmentName: departmentName,
            queueNumber: "A - 24",
            currentServing: "A - 17",
            peopleAhead: 7,
            estimatedWaitMin: 20
        )
    }
}
