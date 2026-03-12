import Foundation

struct LaboratoryTestProgress {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let tests: [TestProgressItem]
    let wardLocation: String
    let estimatedCompletion: String
    
    static let mock = LaboratoryTestProgress(
        title: "Laboratory",
        currentStep: 2,
        totalSteps: 4,
        tests: [
            TestProgressItem(
                name: "Blood Test",
                status: .completed,
                detail: "Collected at ward – 10:30 AM",
                progress: 1.0
            ),
            TestProgressItem(
                name: "X-Ray",
                status: .inProgress,
                detail: "Scheduled for 2:00 PM",
                progress: 0.6
            ),
            TestProgressItem(
                name: "X-Ray",
                status: .pending,
                detail: "Will be done at bedside",
                progress: 0.3
            )
        ],
        wardLocation: "Ward 3B – Room 305",
        estimatedCompletion: "Today, 4:00 PM"
    )
}

struct TestProgressItem: Identifiable {
    let id = UUID()
    let name: String
    let status: TestStatus
    let detail: String
    let progress: Double
}

enum TestStatus {
    case completed
    case inProgress
    case pending
    
    var color: (red: Double, green: Double, blue: Double) {
        switch self {
        case .completed:
            return (76.0 / 255, 175.0 / 255, 80.0 / 255) // Green
        case .inProgress:
            return (33.0 / 255, 150.0 / 255, 243.0 / 255) // Blue
        case .pending:
            return (158.0 / 255, 158.0 / 255, 158.0 / 255) // Gray
        }
    }
    
    var title: String {
        switch self {
        case .completed:
            return "Completed"
        case .inProgress:
            return "In Progress"
        case .pending:
            return "Pending"
        }
    }
}
