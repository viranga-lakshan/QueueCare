import Foundation

// MARK: – Book Doctor Progress

enum BookDoctorStatus {
    case scheduled(dateLabel: String, timeLabel: String)
    case inQueue(token: String, currentServing: String, peopleAhead: Int, estimatedWaitMin: Int)
    case completed

    var label: String {
        switch self {
        case .scheduled:  return "Scheduled"
        case .inQueue:    return "In Queue"
        case .completed:  return "Completed"
        }
    }
}

struct BookDoctorProgress {
    let departmentName: String
    let imageName: String
    let theme: DepartmentAccentTheme
    let status: BookDoctorStatus
    
    var sfSymbol: String {
        switch departmentName {
        case "General OPD":
            return "stethoscope.circle.fill"
        case "Pediatrics":
            return "figure.and.child.holdinghands"
        case "Cardiology":
            return "heart.text.square.fill"
        case "Ophthalmology":
            return "eye.circle.fill"
        default:
            return "cross.case.fill"
        }
    }
}

// MARK: – Lab Progress

enum LabStatus {
    case scheduled(dateLabel: String, timeLabel: String)
    case inQueue(token: String, currentServing: String, peopleAhead: Int, estimatedWaitMin: Int)
    case completed

    var label: String {
        switch self {
        case .scheduled:  return "Scheduled"
        case .inQueue:    return "In Queue"
        case .completed:  return "Completed"
        }
    }
}

struct LabProgress {
    let status: LabStatus
    let dateLabel: String
    let timeLabel: String
}

// MARK: – Pharmacy Progress

enum PharmacyProgressStatus {
    case preparing
    case inQueue
    case completed

    var label: String {
        switch self {
        case .preparing:  return "Preparing Medicines"
        case .inQueue:    return "In Queue"
        case .completed:  return "Completed"
        }
    }
}

struct PharmacyProgressEntry {
    let status: PharmacyProgressStatus
}
