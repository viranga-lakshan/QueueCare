import Foundation

struct LaboratoryAppointment {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let selectedDate: Date
    let availableTimeSlots: [TimeSlot]
    let selectedTimeSlotID: String?
    let preparation: PreparationInfo
    let estimatedDuration: String
    let buttonTitle: String
    
    static let mock = LaboratoryAppointment(
        title: "Laboratory",
        currentStep: 3,
        totalSteps: 7,
        selectedDate: Date(timeIntervalSince1970: 1773792000), // March 15, 2026
        availableTimeSlots: [
            TimeSlot(id: "slot1", time: "09:00"),
            TimeSlot(id: "slot2", time: "10:30"),
            TimeSlot(id: "slot3", time: "14:00")
        ],
        selectedTimeSlotID: nil,
        preparation: PreparationInfo(
            title: "Preparation Required",
            items: [
                "Fasting for 8-12 hours",
                "Bring ID and insurance card"
            ]
        ),
        estimatedDuration: "45 minutes",
        buttonTitle: "Confirm Appointment"
    )
}

struct TimeSlot: Identifiable {
    let id: String
    let time: String
}

struct PreparationInfo {
    let title: String
    let items: [String]
}
