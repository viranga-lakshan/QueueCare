import SwiftUI

struct AppointmentSuccessView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let confirmGreen = Color(red: 52 / 255, green: 168 / 255, blue: 83 / 255)

    var body: some View {
        ZStack {
            // Blurred background showing the book appointment screen underneath
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 18)
                    .padding(.horizontal, 22)

                Spacer()

                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(confirmGreen)

                    VStack(spacing: 10) {
                        Text("Appointment Book\nSuccessfully")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                            .multilineTextAlignment(.center)

                        Text("Your appointment has been added to the\nprogress menu")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()

                Button(action: controller.showDashboard) {
                    Text("Exit")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.bottom, 48)
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showAppointmentPayment) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.92, green: 0.95, blue: 0.95).opacity(0.96))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            }

            Spacer(minLength: 0)

            BundleResourceImage(name: controller.dashboard.avatarImageName, fallbackSystemName: "person.crop.circle.fill")
                .frame(width: 34, height: 34)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white, lineWidth: 2))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }
}

#Preview {
    AppointmentSuccessView(controller: QueueController())
}
