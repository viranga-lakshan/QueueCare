import Foundation

struct PharmacyStatus {
    let title: String
    let heading: String
    let subtitle: String
    let currentStatusLabel: String
    let currentStatusValue: String
    let medicationsTitle: String
    let buttonTitle: String
    let medications: [PrescribedMedication]

    static let mock = PharmacyStatus(
        title: "Pharmacy",
        heading: "Prescription Sent to\nPharmacy",
        subtitle: "Your medicines are being prepared",
        currentStatusLabel: "Current Status",
        currentStatusValue: "Preparing Bill",
        medicationsTitle: "Prescribed Medicines",
        buttonTitle: "View Pharmacy Status",
        medications: [
            PrescribedMedication(
                name: "Paracetamol 500mg",
                dosage: "1 tablet, 3 times daily",
                schedule: "After meals - 5 days"
            ),
            PrescribedMedication(
                name: "Amoxicillin 250mg",
                dosage: "1 capsule, 2 times daily",
                schedule: "Before meals - 7 days"
            ),
            PrescribedMedication(
                name: "Vitamin D 1000 IU",
                dosage: "1 tablet, once daily",
                schedule: "After breakfast - 30 days"
            )
        ]
    )
}

struct PrescribedMedication: Identifiable {
    let id = UUID()
    let name: String
    let dosage: String
    let schedule: String
}