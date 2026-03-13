import SwiftUI

struct PaymentView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.43, green: 0.46, blue: 0.49)
    private let cardTint = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let amountCardColor = Color(red: 163 / 255, green: 210 / 255, blue: 177 / 255)

    @State private var selectedMethod: PaymentMethod = .card
    @State private var showPaymentSuccess = false

    enum PaymentMethod {
        case card
        case cash
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)

                    paymentIcon
                        .padding(.top, 42)

                    VStack(spacing: 8) {
                        Text("Payment")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Choose payment method")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 26)

                    totalAmountCard
                        .padding(.top, 32)

                    VStack(spacing: 14) {
                        paymentOptionCard(
                            title: "Card Payment",
                            subtitle: "Credit or Debit card",
                            systemImage: "creditcard.fill",
                            method: .card
                        )

                        paymentOptionCard(
                            title: "Cash Payments",
                            subtitle: "Cash payments only",
                            systemImage: "banknote.fill",
                            method: .cash
                        )
                    }
                    .padding(.top, 26)

                    Button {
                        showPaymentSuccess = true
                    } label: {
                        HStack(spacing: 12) {
                            Text("Confirm Payment")
                                .font(.system(size: 20, weight: .bold, design: .rounded))

                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 40)
                    .padding(.bottom, 36)
                }
                .padding(.horizontal, 30)
            }
        }
        .sheet(isPresented: $showPaymentSuccess) {
            PaymentSuccessModal(
                brandColor: brandColor,
                textColor: textColor,
                mutedTextColor: mutedTextColor
            ) {
                controller.completePharmacyPaymentAndShowDashboard()
            }
            .presentationDetents([.medium])
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
            Button(action: controller.showPharmacyStatus) {
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

    private var paymentIcon: some View {
        ZStack {
            Circle()
                .fill(cardTint)
                .frame(width: 96, height: 96)

            BundleResourceImage(name: "pharmacy", subdirectory: "pharmacy", fallbackSystemName: "doc.text.fill")
                .frame(width: 40, height: 40)
        }
    }

    private var totalAmountCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total Amount")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(textColor.opacity(0.8))

            Text("Rs.361.75")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 22)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(amountCardColor)
        )
    }

    private func paymentOptionCard(title: String, subtitle: String, systemImage: String, method: PaymentMethod) -> some View {
        let isSelected = selectedMethod == method

        return Button {
            selectedMethod = method
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(red: 230 / 255, green: 234 / 255, blue: 239 / 255))
                        .frame(width: 44, height: 44)

                    Image(systemName: systemImage)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(textColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .stroke(Color(red: 186 / 255, green: 196 / 255, blue: 214 / 255), lineWidth: 2)
                        .frame(width: 34, height: 34)

                    if isSelected {
                        Circle()
                            .fill(Color(red: 43 / 255, green: 79 / 255, blue: 142 / 255))
                            .frame(width: 26, height: 26)

                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct PaymentSuccessModal: View {
    @Environment(\.dismiss) private var dismiss

    let brandColor: Color
    let textColor: Color
    let mutedTextColor: Color
    let onOkay: () -> Void

    var body: some View {
        ZStack {
            Color(red: 0.92, green: 0.95, blue: 0.95)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(brandColor.opacity(0.15))
                        .frame(width: 96, height: 96)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(brandColor)
                }

                VStack(spacing: 8) {
                    Text("Payment Successful")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Your payment has been confirmed.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                        .multilineTextAlignment(.center)
                }

                Button {
                    dismiss()
                    onOkay()
                } label: {
                    Text("Okay")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 6)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 26)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            )
            .padding(.horizontal, 18)
        }
    }
}

#Preview {
    PaymentView(controller: QueueController())
}
