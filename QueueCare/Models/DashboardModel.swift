import Foundation

struct DashboardModel {
    let patientName: String
    let avatarImageName: String
    let children: [String]
    let shortcuts: [DashboardShortcut]
    let currentVisit: DashboardVisit
    let flow: DashboardFlow
    let updates: [DashboardUpdate]

    static let sample = DashboardModel(
        patientName: "User",
        avatarImageName: "PHOTO-2026-03-10-12-35-46",
        children: [],
        shortcuts: [
            DashboardShortcut(title: "Book Doctor", imageName: "doctor", action: .departmentSelection, theme: .blue),
            DashboardShortcut(title: "Lab\nAppointment", imageName: "lab", action: .laboratoryRequest, theme: .sky),
            DashboardShortcut(title: "Pharmacy", imageName: "pharmacy", action: .pharmacyStatus, theme: .mint),
            DashboardShortcut(title: "My Queue/\nStatus", imageName: "queue", action: .queueStatus, theme: .indigo)
        ],
        currentVisit: DashboardVisit(
            departmentName: "Cardiology",
            tokenLabel: "A - 17",
            servingLabel: "A - 12",
            peopleAhead: 5,
            etaText: "~ 25 min"
        ),
        flow: DashboardFlow(
            title: "Next Step",
            buttonTitle: "Continue flow",
            steps: [
                DashboardFlowStep(title: "Registration", state: .completed),
                DashboardFlowStep(title: "Consultation", state: .current),
                DashboardFlowStep(title: "Laboratory", state: .upcoming)
            ]
        ),
        updates: [
            DashboardUpdate(title: "Pharmacy bill ready for payment", actionTitle: "Pay", actionDestination: nil, icon: .attention),
            DashboardUpdate(title: "Lab appointment confirmed for Thu. 9:30 AM", actionTitle: "View", actionDestination: .progress, icon: .confirmed),
            DashboardUpdate(title: "Test results are ready", actionTitle: "Download", actionDestination: nil, icon: .attention)
        ]
    )
}

struct DashboardShortcut: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let action: DashboardShortcutAction
    let theme: DashboardAccentTheme
}

enum DashboardShortcutAction {
    case departmentSelection
    case laboratoryRequest
    case pharmacyStatus
    case queueStatus
    case tab(DashboardTab)
}

struct DashboardVisit {
    let departmentName: String
    let tokenLabel: String
    let servingLabel: String
    let peopleAhead: Int
    let etaText: String
}

struct DashboardFlow {
    let title: String
    let buttonTitle: String
    let steps: [DashboardFlowStep]
}

struct DashboardFlowStep: Identifiable {
    let id = UUID()
    let title: String
    let state: DashboardFlowStepState
}

struct DashboardUpdate: Identifiable {
    let id = UUID()
    let title: String
    let actionTitle: String
    let actionDestination: DashboardTab?
    let icon: DashboardUpdateIcon
}

enum DashboardFlowStepState {
    case completed
    case current
    case upcoming
}

enum DashboardUpdateIcon {
    case attention
    case confirmed
}

enum DashboardAccentTheme {
    case blue
    case sky
    case mint
    case indigo
}

enum DashboardTab: String, CaseIterable, Identifiable {
    case home
    case map
    case progress
    case user

    var id: String { rawValue }
    static let visibleTabs: [DashboardTab] = [.home, .map, .progress, .user]

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .map:
            return "Map"
        case .progress:
            return "Progress"
        case .user:
            return "User"
        }
    }

    var imageName: String {
        switch self {
        case .home:
            return "home"
        case .map:
            return "map"
        case .progress:
            return "progress"
        case .user:
            return "user"
        }
    }

    var fallbackSystemName: String {
        switch self {
        case .home:
            return "house.fill"
        case .map:
            return "map.fill"
        case .progress:
            return "scope"
        case .user:
            return "person.fill"
        }
    }
}