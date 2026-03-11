import Foundation

struct LaboratoryInpatientStatus {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let heading: String
    let orderedTestsLabel: String
    let orderedTests: [String]
    let statusTitle: String
    let statusSubtitle: String
    let wardLabel: String
    let wardValue: String

    static let mock = LaboratoryInpatientStatus(
        title: "Laboratory",
        currentStep: 1,
        totalSteps: 4,
        heading: "Doctor Ordered Lab Tests",
        orderedTestsLabel: "Ordered Tests:",
        orderedTests: ["Blood Test", "X-Ray", "ECG"],
        statusTitle: "Internal Lab Order Sent",
        statusSubtitle: "No appointment booking required",
        wardLabel: "Your Ward",
        wardValue: "Ward 3B – Room 305"
    )
}
