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
                if controller.selectedDashboardTab == .user {
                    UserSectionView(controller: controller)
                } else {
                    DashboardView(controller: controller)
                }
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
            case .laboratoryTestProgress:
                LaboratoryTestProgressView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryTestCompletion:
                LaboratoryTestCompletionView(controller: controller, laboratoryController: controller.laboratoryController)
            case .laboratoryDoctorReview:
                LaboratoryDoctorReviewView(controller: controller, laboratoryController: controller.laboratoryController)
            case .bookAppointment:
                BookAppointmentView(controller: controller)
            case .appointmentPayment:
                AppointmentPaymentView(controller: controller)
            case .appointmentSuccess:
                AppointmentSuccessView(controller: controller)
            case .pharmacyStatus:
                PharmacyStatusView(controller: controller, pharmacyController: controller.pharmacyController)
            case .medicineCollectionQueue:
                MedicineCollectionQueueView(controller: controller)
            case .medicinesReadyProgress:
                MedicinesReadyProgressView(controller: controller)
            case .noActiveQueue:
                NoActiveQueueView(controller: controller)
            case .collectionCompleted:
                CollectionCompletedView(controller: controller)
            case .payment:
                PaymentView(controller: controller)
            case .selectPatient:
                SelectPatientView(controller: controller)
            case .profileSetup:
                ProfileSetupView(controller: controller)
            case .liveQueue:
                LiveQueueView(controller: controller)
            case .departmentProgress:
                DepartmentProgressView(controller: controller)
            case .hospitalNavigation:
                HospitalNavigationView(controller: controller)
            case .helpSupport:
                HelpSupportView(controller: controller)
            }
        }
    }
}

#Preview {
    ContentView(controller: QueueController())
}
