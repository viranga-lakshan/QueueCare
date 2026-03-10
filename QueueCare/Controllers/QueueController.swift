import Foundation
import Combine

@MainActor
final class QueueController: ObservableObject {
    enum Screen {
        case welcome
        case registration
        case verification
        case verificationSuccess
    }

    @Published private(set) var currentScreen: Screen = .welcome
    @Published private(set) var patients: [QueuePatient] = []
    @Published private(set) var waitingCount = 0
    @Published private(set) var activeCount = 0

    private var model = QueueModel()

    init() {
        syncFromModel()
    }

    var onboardingFeatures: [OnboardingFeature] {
        [
            OnboardingFeature(
                iconName: "clock.arrow.circlepath",
                title: "Real-Time Queue Updates",
                subtitle: "Know exactly how long you will wait"
            ),
            OnboardingFeature(
                iconName: "paperplane",
                title: "Easy Navigation",
                subtitle: "Find departments and rooms quickly"
            ),
            OnboardingFeature(
                iconName: "map",
                title: "Track your visit",
                subtitle: "See each step of your clinic journey"
            )
        ]
    }

    func showWelcome() {
        currentScreen = .welcome
    }

    func showRegistration() {
        currentScreen = .registration
    }

    func showVerification() {
        currentScreen = .verification
    }

    func showVerificationSuccess() {
        currentScreen = .verificationSuccess
    }

    func addPatient(name: String) {
        model.addPatient(named: name)
        syncFromModel()
    }

    func callPatient(id: UUID) {
        model.callPatient(id: id)
        syncFromModel()
    }

    func completePatient(id: UUID) {
        model.completePatient(id: id)
        syncFromModel()
    }

    private func syncFromModel() {
        patients = model.patients
        waitingCount = model.waitingCount
        activeCount = model.activeCount
    }
}
