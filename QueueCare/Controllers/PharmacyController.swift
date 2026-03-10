import Foundation
import Combine

@MainActor
final class PharmacyController: ObservableObject {
    @Published private(set) var status = PharmacyStatus.mock

    init() {
        loadMockStatus()
    }

    func loadMockStatus() {
        status = .mock
    }
}