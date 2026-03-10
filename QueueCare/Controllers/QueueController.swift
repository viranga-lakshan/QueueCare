import Foundation
import Combine

@MainActor
final class QueueController: ObservableObject {
    enum Screen {
        case welcome
        case registration
        case verification
        case verificationSuccess
        case dashboard
        case departmentSelection
        case laboratoryRequest
        case laboratoryVisitSelection
        case pharmacyStatus
    }

    @Published private(set) var currentScreen: Screen = .welcome
    @Published private(set) var patients: [QueuePatient] = []
    @Published private(set) var waitingCount = 0
    @Published private(set) var activeCount = 0
    @Published private(set) var selectedDashboardTab: DashboardTab = .home
    @Published private(set) var selectedChildName = ""

    private var model = QueueModel()
    let phoneAuthController = PhoneAuthController()
    let laboratoryController = LaboratoryController()
    let pharmacyController = PharmacyController()

    init() {
        syncFromModel()
        selectedChildName = model.dashboard.children.first ?? ""
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

    var dashboard: DashboardModel {
        model.dashboard
    }

    var availableChildren: [String] {
        model.dashboard.children
    }

    var departmentOptions: [DepartmentOption] {
        model.departmentCatalog.options
    }

    func showWelcome() {
        phoneAuthController.clearError()
        currentScreen = .welcome
    }

    func showRegistration() {
        phoneAuthController.clearError()
        currentScreen = .registration
    }

    func showVerification() {
        phoneAuthController.clearError()
        currentScreen = .verification
    }

    func showVerificationSuccess() {
        currentScreen = .verificationSuccess
    }

    func requestOTP(for phoneNumber: String) async {
        let didSendCode = await phoneAuthController.sendOTP(to: phoneNumber)
        if didSendCode {
            showVerification()
        }
    }

    func verifyOTP(_ code: String) async {
        let didVerifyCode = await phoneAuthController.verifyOTP(code)
        if didVerifyCode {
            showVerificationSuccess()
        }
    }

    func showDashboard() {
        if selectedChildName.isEmpty {
            selectedChildName = availableChildren.first ?? ""
        }

        selectedDashboardTab = .home
        currentScreen = .dashboard
    }

    func showDepartmentSelection() {
        selectedDashboardTab = .home
        currentScreen = .departmentSelection
    }

    func showLaboratoryRequest() {
        selectedDashboardTab = .home
        laboratoryController.loadMockRequest()
        currentScreen = .laboratoryRequest
    }

    func showLaboratoryVisitSelection() {
        selectedDashboardTab = .home
        laboratoryController.loadMockVisitSelection()
        currentScreen = .laboratoryVisitSelection
    }

    func showPharmacyStatus() {
        selectedDashboardTab = .home
        pharmacyController.loadMockStatus()
        currentScreen = .pharmacyStatus
    }

    func selectDashboardTab(_ tab: DashboardTab) {
        selectedDashboardTab = tab
        currentScreen = .dashboard
    }

    func handleDashboardShortcut(_ shortcut: DashboardShortcut) {
        switch shortcut.action {
        case .departmentSelection:
            showDepartmentSelection()
        case .laboratoryRequest:
            showLaboratoryRequest()
        case .pharmacyStatus:
            showPharmacyStatus()
        case let .tab(tab):
            selectDashboardTab(tab)
        }
    }

    func selectChild(named name: String) {
        guard availableChildren.contains(name) else { return }
        selectedChildName = name
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
