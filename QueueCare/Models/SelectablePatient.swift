import Foundation
import SwiftUI

struct SelectablePatient: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let relation: String
    let contactNumber: String
    let gender: String
    let email: String
    let photo: UIImage?
}
