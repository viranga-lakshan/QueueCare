import Foundation
import Combine

@MainActor
final class LaboratoryController: ObservableObject {
    @Published private(set) var request = LaboratoryRequest.mock
    @Published private(set) var visitSelection = LaboratoryVisitSelection.mock
    @Published private(set) var selectedVisitOptionID: LaboratoryVisitOptionID = .outpatient
    @Published private(set) var appointment = LaboratoryAppointment.mock
    @Published var selectedTimeSlotID: String?
    @Published var selectedDate: Date = Date()
    @Published private(set) var payment = LaboratoryPayment.mock
    @Published var selectedPaymentMethodID: String?
    @Published private(set) var confirmation = LaboratoryConfirmation.mock
    @Published private(set) var inpatientStatus = LaboratoryInpatientStatus.mock

    init() {
        loadMockRequest()
        loadMockVisitSelection()
        loadMockAppointment()
        loadMockPayment()
        loadMockConfirmation()
        loadMockInpatientStatus()
    }

    func loadMockRequest() {
        request = .mock
    }

    func loadMockVisitSelection() {
        visitSelection = .mock
        selectedVisitOptionID = visitSelection.options.first(where: \.isEnabled)?.id ?? .outpatient
    }

    func selectVisitOption(_ optionID: LaboratoryVisitOptionID) {
        guard visitSelection.options.contains(where: { $0.id == optionID && $0.isEnabled }) else { return }
        selectedVisitOptionID = optionID
    }
    
    func loadMockAppointment() {
        appointment = .mock
        selectedTimeSlotID = nil
        selectedDate = appointment.selectedDate
    }
    
    func selectTimeSlot(_ slotID: String) {
        guard appointment.availableTimeSlots.contains(where: { $0.id == slotID }) else { return }
        selectedTimeSlotID = slotID
    }
    
    func loadMockPayment() {
        payment = .mock
        selectedPaymentMethodID = payment.selectedPaymentMethodID
    }
    
    func selectPaymentMethod(_ methodID: String) {
        guard payment.paymentMethods.contains(where: { $0.id == methodID }) else { return }
        selectedPaymentMethodID = methodID
    }

    func loadMockConfirmation() {
        confirmation = .mock
    }

    func loadMockInpatientStatus() {
        inpatientStatus = .mock
    }
}
