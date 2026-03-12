import SwiftUI

struct AppointmentPaymentView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    private let cardBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)

    private var payment: AppointmentPayment {
        controller.appointmentPayment
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)
                        .padding(.horizontal, 22)

                    Text("Payments")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                        .padding(.top, 28)

                    // MARK: Summary card
                    VStack(spacing: 0) {
                        summaryRow(label: "Department", value: payment.departmentName)
                        summaryRow(label: "Patient", value: payment.patientName)
                        summaryRow(label: "Date", value: payment.dateLabel, isLast: true)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(cardBlue)
                    )
                    .padding(.horizontal, 22)
                    .padding(.top, 32)

                    // MARK: Payment method label
                    Text("Select Payment Method")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 22)
                        .padding(.top, 28)

                    // MARK: Payment method cards
                    VStack(spacing: 14) {
                        ForEach(payment.paymentMethods) { method in
                            paymentMethodCard(method)
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 12)

                    // MARK: Consultation fee card
                    HStack {
                        Text("Consultation\nFee")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(textColor)

                        Spacer(minLength: 0)

                        Text(payment.formattedFee)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(iconBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 22)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal, 22)
                    .padding(.top, 14)

                    // MARK: Confirm Payment button
                    Button(action: controller.showAppointmentSuccess) {
                        Text("Confirm Payment")
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
                    .padding(.top, 40)
                    .padding(.bottom, 36)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(selectedTab: controller.selectedDashboardTab, accentColor: brandColor) { tab in
                controller.selectDashboardTab(tab)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 0)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -4)
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showBookAppointmentBack) {
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
                .overlay(Circle().stroke(.white, lineWidth: 2))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }

    private func summaryRow(label: String, value: String, isLast: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(mutedTextColor)
            Spacer(minLength: 0)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(mutedTextColor.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
    }

    private func paymentMethodCard(_ method: AppointmentPaymentMethod) -> some View {
        let isSelected = controller.selectedAppointmentPaymentMethodID == method.id

        return Button {
            controller.selectAppointmentPaymentMethod(method.id)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(cardBlue)
                        .frame(width: 44, height: 44)

                    Image(systemName: method.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(iconBlue)
                }

                Text(method.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer(minLength: 0)

                ZStack {
                    Circle()
                        .stroke(isSelected ? iconBlue : mutedTextColor.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(iconBlue)
                            .frame(width: 11, height: 11)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AppointmentPaymentView(controller: QueueController())
}
