import Foundation

struct BookAppointment {
    let departmentName: String
    let timeSlots: [BookingTimeSlot]
    let estimatedWaitMin: Int
    let estimatedWaitMax: Int

    var estimatedWaitLabel: String {
        "Estimate wait : \(estimatedWaitMin) – \(estimatedWaitMax) min"
    }

    static func mock(for departmentName: String) -> BookAppointment {
        BookAppointment(
            departmentName: departmentName,
            timeSlots: [
                BookingTimeSlot(id: "slot1", time: "09:00 AM", isAvailable: true),
                BookingTimeSlot(id: "slot2", time: "10:00 AM", isAvailable: true),
                BookingTimeSlot(id: "slot3", time: "11:00 AM", isAvailable: false),
                BookingTimeSlot(id: "slot4", time: "02:00 PM", isAvailable: true)
            ],
            estimatedWaitMin: 25,
            estimatedWaitMax: 35
        )
    }
}

struct BookingTimeSlot: Identifiable {
    let id: String
    let time: String
    let isAvailable: Bool
}
