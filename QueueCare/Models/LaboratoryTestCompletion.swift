import Foundation

struct LaboratoryTestCompletion {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let heading: String
    let subheading: String
    let completionDate: String
    let completionTime: String
    let testsCompleted: String
    let referenceNumber: String
    let notificationTitle: String
    let notificationMessage: String
    let buttonTitle: String
    
    static let mock = LaboratoryTestCompletion(
        title: "Laboratory",
        currentStep: 3,
        totalSteps: 4,
        heading: "All Tests Completed",
        subheading: "Results are now available",
        completionDate: "March 15, 2026",
        completionTime: "3:45 PM",
        testsCompleted: "3 of 3",
        referenceNumber: "INP-2026-0315",
        notificationTitle: "Automatically Sent to Doctor",
        notificationMessage: "Your attending physician has been notified and will review the results shortly.",
        buttonTitle: "View Report"
    )
}
