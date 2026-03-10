import Foundation
import Combine

@MainActor
final class LaboratoryController: ObservableObject {
    @Published private(set) var request = LaboratoryRequest.mock
    @Published private(set) var visitSelection = LaboratoryVisitSelection.mock
    @Published private(set) var selectedVisitOptionID: LaboratoryVisitOptionID = .outpatient

    init() {
        loadMockRequest()
        loadMockVisitSelection()
    }

    func loadMockRequest() {
        request = .mock
    }

    func loadMockVisitSelection() {
        visitSelection = .mock
        selectedVisitOptionID = visitSelection.options.first(where: \ .isEnabled)?.id ?? .outpatient
    }

    func selectVisitOption(_ optionID: LaboratoryVisitOptionID) {
        guard visitSelection.options.contains(where: { $0.id == optionID && $0.isEnabled }) else { return }
        selectedVisitOptionID = optionID
    }
}