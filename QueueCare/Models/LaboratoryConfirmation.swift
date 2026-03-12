import Foundation

struct LaboratoryConfirmation {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let confirmedDate: Date
    let confirmedTime: String
    let location: String
    let referenceNumber: String
    let preparation: PreparationInfo
    let buttonTitle: String

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: confirmedDate)
    }

    static let mock = LaboratoryConfirmation(
        title: "Laboratory",
        currentStep: 5,
        totalSteps: 7,
        confirmedDate: Date(timeIntervalSince1970: 1773792000), // March 15, 2026
        confirmedTime: "10:30 AM",
        location: "Laboratory – Building A, Floor 2",
        referenceNumber: "LAB-2026-0315",
        preparation: PreparationInfo(
            title: "Preparation Required",
            items: [
                "Fasting for 8–12 hours",
                "Bring ID and insurance card"
            ]
        ),
        buttonTitle: "Done"
    )
}
