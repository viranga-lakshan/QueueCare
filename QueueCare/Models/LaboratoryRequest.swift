import Foundation

struct LaboratoryRequest {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let heading: String
    let doctorName: String
    let description: String
    let cardTitle: String
    let buttonTitle: String
    let tests: [LaboratoryTest]

    static let mock = LaboratoryRequest(
        title: "Laboratory",
        currentStep: 1,
        totalSteps: 7,
        heading: "Lab Test Required",
        doctorName: "Dr. Carter",
        description: "has requested the following laboratory tests based on your consultation.",
        cardTitle: "Requested Tests",
        buttonTitle: "Proceed to Laboratory",
        tests: [
            LaboratoryTest(name: "Completed Blood Count", icon: .blood),
            LaboratoryTest(name: "Chest X-Ray", icon: .xray),
            LaboratoryTest(name: "Electrocardiogram (ECG)", icon: .ecg)
        ]
    )
}

struct LaboratoryTest: Identifiable {
    let id = UUID()
    let name: String
    let icon: LaboratoryTestIcon
}

enum LaboratoryTestIcon {
    case blood
    case xray
    case ecg

    var systemName: String {
        switch self {
        case .blood:
            return "drop.fill"
        case .xray:
            return "list.clipboard.fill"
        case .ecg:
            return "waveform.path.ecg"
        }
    }
}