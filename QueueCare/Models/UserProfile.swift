import UIKit

struct UserProfile {
    var name: String
    var contactNumber: String
    var email: String
    var gender: String        // "Male" | "Female" | "Other"
    var photo: UIImage?

    static let empty = UserProfile(name: "", contactNumber: "", email: "", gender: "Male", photo: nil)
}
