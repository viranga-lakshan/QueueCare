import SwiftUI

struct ContentView: View {
    @ObservedObject var controller: QueueController

    var body: some View {
        Group {
            switch controller.currentScreen {
            case .welcome:
                WelcomeView(controller: controller)
            case .registration:
                PatientRegistrationView(controller: controller)
            case .verification:
                VerificationView(controller: controller)
            case .verificationSuccess:
                VerificationSuccessView(controller: controller)
            }
        }
    }
}

#Preview {
    ContentView(controller: QueueController())
}
