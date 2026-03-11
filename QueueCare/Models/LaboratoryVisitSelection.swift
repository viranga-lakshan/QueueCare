import Foundation

struct LaboratoryVisitSelection {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let buttonTitle: String
    let options: [LaboratoryVisitOption]

    static let mock = LaboratoryVisitSelection(
        title: "Laboratory",
        currentStep: 1,
        totalSteps: 7,
        buttonTitle: "Proceed to Laboratory",
        options: [
            LaboratoryVisitOption(
                id: .outpatient,
                title: "Outpatient\nLaboratory",
                subtitle: "Book Appointment and\nvisit lab",
                icon: .outpatient,
                isEnabled: true
            ),
            LaboratoryVisitOption(
                id: .inpatient,
                title: "Inpatient\nLaboratory",
                subtitle: "Tests conducted in ward",
                icon: .inpatient,
                isEnabled: true
            )
        ]
    )
}

struct LaboratoryVisitOption: Identifiable {
    let id: LaboratoryVisitOptionID
    let title: String
    let subtitle: String
    let icon: LaboratoryVisitIcon
    let isEnabled: Bool
}

enum LaboratoryVisitOptionID: String, Identifiable {
    case outpatient
    case inpatient

    var id: String { rawValue }
}

enum LaboratoryVisitIcon {
    case outpatient
    case inpatient

    var systemName: String {
        switch self {
        case .outpatient:
            return "cross.case"
        case .inpatient:
            return "bed.double"
        }
    }
}