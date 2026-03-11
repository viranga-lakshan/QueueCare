import Foundation
import Combine
import UIKit

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
        case laboratoryAppointment
        case laboratoryPayment
        case laboratoryConfirmation
        case laboratoryInpatientStatus
        case bookAppointment
        case appointmentPayment
        case appointmentSuccess
        case pharmacyStatus
        case medicineCollectionQueue
        case medicinesReadyProgress
        case noActiveQueue
        case collectionCompleted
        case payment
        case selectPatient
        case profileSetup
        case liveQueue
        case departmentProgress
    }

    @Published private(set) var currentScreen: Screen = .welcome
    @Published private(set) var patients: [QueuePatient] = []
    @Published private(set) var waitingCount = 0
    @Published private(set) var activeCount = 0
    @Published private(set) var selectedDashboardTab: DashboardTab = .home
    @Published private(set) var selectedChildName = ""
    @Published private(set) var bookAppointment: BookAppointment = .mock(for: "")
    @Published var selectedBookingDate: Date = Date()
    @Published var selectedBookingSlotID: String?
    @Published private(set) var appointmentPayment: AppointmentPayment = .mock(departmentName: "", patientName: "")
    @Published var selectedAppointmentPaymentMethodID: String = "card"
    @Published private(set) var isMedicineReady = false
    @Published private(set) var hasActiveQueue = false
    @Published private(set) var selectablePatients: [SelectablePatient] = []
    @Published private(set) var userProfile: UserProfile = .empty
    @Published private(set) var liveQueue: LiveQueueModel = .mock(for: "")
    @Published private(set) var bookDoctorProgress: BookDoctorProgress? = nil
    @Published private(set) var labProgress: LabProgress? = nil
    @Published private(set) var pharmacyProgressEntry: PharmacyProgressEntry? = nil

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
        let modelChildren = model.dashboard.children
        let patientNames = selectablePatients.map(\.name)
        return modelChildren + patientNames.filter { !modelChildren.contains($0) }
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

    func showProfileSetup() {
        currentScreen = .profileSetup
    }

    func saveUserProfile(_ profile: UserProfile) {
        userProfile = profile
        showDashboard()
    }

    func showLiveQueue() {
        liveQueue = .mock(for: bookAppointment.departmentName)
        // Record Book Doctor progress as In Queue
        let option = departmentOptions.first { $0.title == bookAppointment.departmentName }
        bookDoctorProgress = BookDoctorProgress(
            departmentName: bookAppointment.departmentName,
            imageName: option?.imageName ?? "generalOPD",
            theme: option?.theme ?? .blue,
            status: .inQueue(
                token: liveQueue.queueNumber,
                currentServing: liveQueue.currentServing,
                peopleAhead: liveQueue.peopleAhead,
                estimatedWaitMin: liveQueue.estimatedWaitMin
            )
        )
        currentScreen = .liveQueue
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
    
    func showLaboratoryAppointment() {
        selectedDashboardTab = .home
        laboratoryController.loadMockAppointment()
        currentScreen = .laboratoryAppointment
    }
    
    func showLaboratoryPayment() {
        selectedDashboardTab = .home
        laboratoryController.loadMockPayment()
        currentScreen = .laboratoryPayment
    }

    func showLaboratoryConfirmation() {
        selectedDashboardTab = .home
        laboratoryController.loadMockConfirmation()
        // Record Lab progress as Scheduled
        let conf = laboratoryController.confirmation
        labProgress = LabProgress(
            status: .scheduled(dateLabel: conf.formattedDate, timeLabel: conf.confirmedTime),
            dateLabel: conf.formattedDate,
            timeLabel: conf.confirmedTime
        )
        currentScreen = .laboratoryConfirmation
    }

    func showLaboratoryInpatientStatus() {
        selectedDashboardTab = .home
        laboratoryController.loadMockInpatientStatus()
        // Record Lab progress as In Queue
        let conf = laboratoryController.confirmation
        labProgress = LabProgress(
            status: .inQueue(
                token: "L - 12",
                currentServing: "L - 08",
                peopleAhead: 4,
                estimatedWaitMin: 15
            ),
            dateLabel: conf.formattedDate,
            timeLabel: conf.confirmedTime
        )
        currentScreen = .laboratoryInpatientStatus
    }

    func showBookAppointment(for option: DepartmentOption) {
        selectedDashboardTab = .home
        bookAppointment = .mock(for: option.title)
        selectedBookingDate = Date()
        selectedBookingSlotID = nil
        currentScreen = .bookAppointment
    }

    func selectBookingSlot(_ slotID: String) {
        selectedBookingSlotID = slotID
    }

    func showAppointmentPayment() {
        selectedDashboardTab = .home
        appointmentPayment = .mock(departmentName: bookAppointment.departmentName, patientName: dashboard.patientName)
        selectedAppointmentPaymentMethodID = "card"
        currentScreen = .appointmentPayment
    }

    func showBookAppointmentBack() {
        selectedDashboardTab = .home
        currentScreen = .bookAppointment
    }

    func selectAppointmentPaymentMethod(_ id: String) {
        selectedAppointmentPaymentMethodID = id
    }

    func showAppointmentSuccess() {
        selectedDashboardTab = .home
        // Record Book Doctor progress as Scheduled
        let option = departmentOptions.first { $0.title == bookAppointment.departmentName }
        let slotTime = bookAppointment.timeSlots.first { $0.id == selectedBookingSlotID }?.time ?? "–"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        bookDoctorProgress = BookDoctorProgress(
            departmentName: bookAppointment.departmentName,
            imageName: option?.imageName ?? "generalOPD",
            theme: option?.theme ?? .blue,
            status: .scheduled(
                dateLabel: dateFormatter.string(from: selectedBookingDate),
                timeLabel: slotTime
            )
        )
        currentScreen = .appointmentSuccess
    }

    func showPharmacyStatus() {
        selectedDashboardTab = .home
        pharmacyController.loadMockStatus()
        // Record Pharmacy progress as Preparing
        pharmacyProgressEntry = PharmacyProgressEntry(status: .preparing)
        currentScreen = .pharmacyStatus
    }

    func showPayment() {
        selectedDashboardTab = .home
        currentScreen = .payment
    }

    func showMedicineCollectionQueue() {
        selectedDashboardTab = .progress
        hasActiveQueue = true
        // Update Pharmacy progress to In Queue
        pharmacyProgressEntry = PharmacyProgressEntry(status: .inQueue)
        currentScreen = .medicineCollectionQueue
    }

    func completeMedicineQueueAndShowDashboard() {
        isMedicineReady = true
        showDashboard()
    }

    func showCollectionCompleted() {
        selectedDashboardTab = .progress
        // Update Pharmacy progress to Completed
        pharmacyProgressEntry = PharmacyProgressEntry(status: .completed)
        currentScreen = .collectionCompleted
    }

    func selectDashboardTab(_ tab: DashboardTab) {
        selectedDashboardTab = tab
        switch tab {
        case .home, .queue, .user:
            currentScreen = .dashboard
        case .progress:
            showQueueStatus()
        }
    }

    func handleDashboardShortcut(_ shortcut: DashboardShortcut) {
        switch shortcut.action {
        case .departmentSelection:
            showDepartmentSelection()
        case .laboratoryRequest:
            showLaboratoryVisitSelection()
        case .pharmacyStatus:
            showPharmacyStatus()
        case .queueStatus:
            showQueueStatus()
        case let .tab(tab):
            selectDashboardTab(tab)
        }
    }

    func showQueueStatus() {
        selectedDashboardTab = .progress
        currentScreen = .departmentProgress
    }

    func selectChild(named name: String) {
        let validNames = model.dashboard.children + selectablePatients.map(\.name)
        guard validNames.contains(name) else { return }
        selectedChildName = name
    }

    func showSelectPatient() {
        selectedDashboardTab = .home
        currentScreen = .selectPatient
    }

    func addSelectablePatient(name: String, age: Int, relation: String, contactNumber: String, gender: String, email: String, photo: UIImage?) {
        let patient = SelectablePatient(name: name, age: age, relation: relation, contactNumber: contactNumber, gender: gender, email: email, photo: photo)
        selectablePatients.append(patient)
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
