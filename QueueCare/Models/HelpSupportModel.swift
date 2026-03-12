import Foundation

struct HelpSupportModel {
    let sections: [HelpSection]
    let contactInfo: ContactInfo
    let emergencyNumber: String
    
    static let sample = HelpSupportModel(
        sections: [
            HelpSection(
                id: "appointments",
                icon: "calendar.badge.clock",
                title: "Appointments",
                description: "Book and manage your appointments",
                items: [
                    HelpItem(question: "How do I book a doctor appointment?", answer: "Go to the Home screen, tap 'Book Doctor', select your department, choose a time slot, and confirm your booking."),
                    HelpItem(question: "Can I reschedule my appointment?", answer: "Yes, go to Progress tab, find your appointment, and tap 'Reschedule' to select a new time."),
                    HelpItem(question: "How do I cancel an appointment?", answer: "Navigate to your appointments in the Progress tab and select 'Cancel Appointment'.")
                ]
            ),
            HelpSection(
                id: "queue",
                icon: "list.bullet.rectangle",
                title: "Queue & Status",
                description: "Track your position in queue",
                items: [
                    HelpItem(question: "How do I check my queue status?", answer: "Tap on the Queue tab at the bottom to see your current position and estimated wait time."),
                    HelpItem(question: "What does 'People Ahead' mean?", answer: "This shows how many patients are waiting before you. Your turn is coming soon when this number is low."),
                    HelpItem(question: "Will I get notified when it's my turn?", answer: "Yes, you'll receive a push notification when you're next in line.")
                ]
            ),
            HelpSection(
                id: "pharmacy",
                icon: "cross.case.fill",
                title: "Pharmacy",
                description: "Prescription and medicine collection",
                items: [
                    HelpItem(question: "How do I collect my medicines?", answer: "After your consultation, check the Pharmacy status. When ready, go to the pharmacy counter with your token number."),
                    HelpItem(question: "How long does it take?", answer: "Typically 15-30 minutes after your prescription is submitted by the doctor."),
                    HelpItem(question: "Can someone else collect for me?", answer: "Yes, they need your token number and a valid ID.")
                ]
            ),
            HelpSection(
                id: "lab",
                icon: "cross.vial.fill",
                title: "Laboratory Tests",
                description: "Book tests and view results",
                items: [
                    HelpItem(question: "How do I book a lab test?", answer: "Tap 'Lab Appointment' on the home screen, select your visit type, choose tests, and confirm booking."),
                    HelpItem(question: "When will I get my results?", answer: "Most results are available within 24-48 hours. You'll be notified when they're ready."),
                    HelpItem(question: "Where can I view my reports?", answer: "Go to Medical Records in the Quick Actions section on the home screen.")
                ]
            ),
            HelpSection(
                id: "navigation",
                icon: "map.fill",
                title: "Hospital Navigation",
                description: "Find departments and facilities",
                items: [
                    HelpItem(question: "How do I find a department?", answer: "Use the Hospital Navigation feature from Quick Actions. You can zoom and pan to locate any department."),
                    HelpItem(question: "Where is the pharmacy?", answer: "The pharmacy is located on the ground floor, right side. Check the Hospital Navigation map for exact location."),
                    HelpItem(question: "Is there parking available?", answer: "Yes, parking is available at the main entrance. Please contact reception for details.")
                ]
            ),
            HelpSection(
                id: "account",
                icon: "person.circle.fill",
                title: "Account & Profile",
                description: "Manage your account settings",
                items: [
                    HelpItem(question: "How do I update my profile?", answer: "Go to the User tab, tap on your profile, and select 'Edit Profile' to update your information."),
                    HelpItem(question: "Can I add family members?", answer: "Yes, tap 'Add Patient' on the home screen to add family members to your account."),
                    HelpItem(question: "How do I change my phone number?", answer: "Contact hospital reception or use the 'Update Contact' option in your profile settings.")
                ]
            )
        ],
        contactInfo: ContactInfo(
            phoneNumber: "+94 11 234 5678",
            email: "support@hospital.lk",
            whatsapp: "+94 77 123 4567",
            hours: "24/7 Available"
        ),
        emergencyNumber: "1990"
    )
}

struct HelpSection: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let items: [HelpItem]
}

struct HelpItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct ContactInfo {
    let phoneNumber: String
    let email: String
    let whatsapp: String
    let hours: String
}
