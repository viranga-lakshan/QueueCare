import SwiftUI

struct ContentView: View {
    @ObservedObject var controller: QueueController

    var body: some View {
        Group {
            switch controller.currentScreen {
            case .welcome:
                WelcomeView(controller: controller)
            case .registration:
                PatientRegistrationView(controller: controller, phoneAuthController: controller.phoneAuthController)
            case .verification:
                VerificationView(controller: controller, phoneAuthController: controller.phoneAuthController)
            case .verificationSuccess:
                VerificationSuccessView(controller: controller, phoneAuthController: controller.phoneAuthController)
            case .dashboard:
                DashboardView(controller: controller)
            case .departmentSelection:
                DepartmentSelectionView(controller: controller)
            case .laboratoryRequest:
                LaboratoryRequestView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryVisitSelection:
                LaboratoryVisitSelectionView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryAppointment:
                LaboratoryAppointmentView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryPayment:
                LaboratoryPaymentView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryConfirmation:
                LaboratoryConfirmationView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryInpatientStatus:
                LaboratoryInpatientStatusView(controller: controller, laboratoryController: controller.laboratoryController)
            case .bookAppointment:
                BookAppointmentView(controller: controller)
            case .appointmentPayment:
                AppointmentPaymentView(controller: controller)
            case .appointmentSuccess:
                AppointmentSuccessView(controller: controller)
            case .pharmacyStatus:
                PharmacyStatusView(controller: controller, pharmacyController: controller.pharmacyController)
            }
        }
    }
}

#Preview {
    ContentView(controller: QueueController())
}
