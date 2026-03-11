import SwiftUI

struct LaboratoryConfirmationView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let cardBackgroundBeige = Color(red: 242 / 255, green: 235 / 255, blue: 227 / 255)
    private let warningRed = Color(red: 190 / 255, green: 68 / 255, blue: 68 / 255)
    private let confirmGreen = Color(red: 52 / 255, green: 168 / 255, blue: 83 / 255)

    private var confirmation: LaboratoryConfirmation {
        laboratoryController.confirmation
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)
                        .padding(.horizontal, 22)

                    VStack(spacing: 6) {
                        Text(confirmation.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Step \(confirmation.currentStep) / \(confirmation.totalSteps)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 24)

                    confirmationCard
                        .padding(.horizontal, 22)
                        .padding(.top, 36)

                    preparationCard
                        .padding(.horizontal, 22)
                        .padding(.top, 20)

                    Button(action: {}) {
                        Text(confirmation.buttonTitle)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(brandColor)
                                    .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 22)
                    .padding(.top, 48)
                    .padding(.bottom, 36)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(selectedTab: controller.selectedDashboardTab, accentColor: brandColor) { tab in
                controller.selectDashboardTab(tab)
            }
            .padding(.top, 8)
            .background(backgroundColor.opacity(0.97))
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showLaboratoryPayment) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.96))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            }

            Spacer(minLength: 0)

            BundleResourceImage(name: controller.dashboard.avatarImageName, fallbackSystemName: "person.crop.circle.fill")
                .frame(width: 34, height: 34)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }

    private var confirmationCard: some View {
        VStack(spacing: 0) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 68))
                .foregroundStyle(confirmGreen)
                .padding(.top, 28)
                .padding(.bottom, 10)

            Text("Appointment\nConfirmed")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)

            Divider()
                .padding(.horizontal, 20)

            infoRow(label: "Date & Time", value: "\(confirmation.formattedDate) at \(confirmation.confirmedTime)")

            Divider()
                .padding(.horizontal, 20)

            infoRow(label: "Location", value: confirmation.location)

            Divider()
                .padding(.horizontal, 20)

            infoRowHighlighted(label: "Reference Number", value: confirmation.referenceNumber)
                .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
        )
    }

    private func infoRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(mutedTextColor)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private func infoRowHighlighted(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(mutedTextColor)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(brandColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var preparationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(confirmation.preparation.title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(warningRed)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(confirmation.preparation.items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(textColor)
                        Text(item)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(textColor)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(cardBackgroundBeige)
        )
    }
}

#Preview {
    LaboratoryConfirmationView(
        controller: QueueController(),
        laboratoryController: LaboratoryController()
    )
}
