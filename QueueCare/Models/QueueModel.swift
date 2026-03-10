import Foundation

struct QueuePatient: Identifiable, Equatable {
    enum Status: String, CaseIterable {
        case waiting = "Waiting"
        case called = "Called"
        case completed = "Completed"
    }

    let id: UUID
    var name: String
    let checkInTime: Date
    var status: Status

    init(id: UUID = UUID(), name: String, checkInTime: Date = Date(), status: Status = .waiting) {
        self.id = id
        self.name = name
        self.checkInTime = checkInTime
        self.status = status
    }
}

struct QueueModel {
    private(set) var patients: [QueuePatient] = []

    mutating func addPatient(named name: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedName.isEmpty else { return }
        patients.append(QueuePatient(name: cleanedName))
    }

    mutating func callPatient(id: UUID) {
        updateStatus(id: id, to: .called)
    }

    mutating func completePatient(id: UUID) {
        updateStatus(id: id, to: .completed)
    }

    var waitingCount: Int {
        patients.filter { $0.status == .waiting }.count
    }

    var activeCount: Int {
        patients.filter { $0.status != .completed }.count
    }

    private mutating func updateStatus(id: UUID, to status: QueuePatient.Status) {
        guard let index = patients.firstIndex(where: { $0.id == id }) else { return }
        patients[index].status = status
    }
}
