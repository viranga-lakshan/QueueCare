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
            }
        }
    }
}

#Preview {
    ContentView(controller: QueueController())
}
