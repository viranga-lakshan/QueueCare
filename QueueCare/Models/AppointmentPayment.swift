import Foundation

struct AppointmentPayment {
    let departmentName: String
    let patientName: String
    let dateLabel: String
    let consultationFee: Double
    let paymentMethods: [AppointmentPaymentMethod]

    var formattedFee: String {
        String(format: "Rs. %.0f", consultationFee)
    }

    static func mock(departmentName: String, patientName: String) -> AppointmentPayment {
        AppointmentPayment(
            departmentName: departmentName,
            patientName: patientName,
            dateLabel: "Today",
            consultationFee: 5000,
            paymentMethods: [
                AppointmentPaymentMethod(id: "card", title: "Credit / Debit Card", icon: "creditcard.fill"),
                AppointmentPaymentMethod(id: "cash", title: "Cash", icon: "banknote.fill")
            ]
        )
    }
}

struct AppointmentPaymentMethod: Identifiable {
    let id: String
    let title: String
    let icon: String
}
