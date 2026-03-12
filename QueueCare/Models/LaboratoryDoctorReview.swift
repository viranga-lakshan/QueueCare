import Foundation

struct LaboratoryDoctorReview {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let heading: String
    let doctor: DoctorInfo
    let reviewStatus: ReviewStatus
    let nextSteps: [NextStepItem]
    let expectedDischarge: DischargeInfo
    
    struct DoctorInfo {
        let name: String
        let specialty: String
        let initials: String
    }
    
    struct ReviewStatus {
        let title: String
        let statusText: String
        let isCompleted: Bool
    }
    
    struct NextStepItem: Identifiable {
        let id = UUID()
        let stepNumber: Int
        let description: String
    }
    
    struct DischargeInfo {
        let title: String
        let date: String
    }
    
    static let mock = LaboratoryDoctorReview(
        title: "Laboratory",
        currentStep: 4,
        totalSteps: 4,
        heading: "Doctor Reviewed Results",
        doctor: DoctorInfo(
            name: "Dr. Sarah Jhonson",
            specialty: "Internal Medicine",
            initials: "Dr"
        ),
        reviewStatus: ReviewStatus(
            title: "Review Status",
            statusText: "Reviewed and Updated",
            isCompleted: true
        ),
        nextSteps: [
            NextStepItem(
                stepNumber: 1,
                description: "Your attending physician has been notified and will review the results shortly."
            ),
            NextStepItem(
                stepNumber: 2,
                description: "Follow-up appointment scheduled with your doctor to discuss the test results."
            )
        ],
        expectedDischarge: DischargeInfo(
            title: "Expected Discharge",
            date: "March 17, 2026"
        )
    )
}
