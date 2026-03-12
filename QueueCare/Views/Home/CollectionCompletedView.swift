import SwiftUI

struct CollectionCompletedView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.43, green: 0.46, blue: 0.49)

    private var medications: [PrescribedMedication] {
        controller.pharmacyController.status.medications
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)

                    successIcon
                        .padding(.top, 42)

                    VStack(spacing: 10) {
                        Text("Collection Completed")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                            .multilineTextAlignment(.center)

                        Text("Thank you for using our Pharmacy Service!")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color(red: 22 / 255, green: 129 / 255, blue: 66 / 255))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 26)

                    collectedMedicinesCard
                        .padding(.top, 30)

                    remindersCard
                        .padding(.top, 26)

                    transactionCard
                        .padding(.top, 24)

                    Button {
                        controller.showDashboard()
                    } label: {
                        Text("Return to Dashboard")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
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
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 26)
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
            Button(action: controller.showDashboard) {
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

    private var successIcon: some View {
        ZStack {
            Circle()
                .fill(Color(red: 186 / 255, green: 220 / 255, blue: 189 / 255))
                .frame(width: 108, height: 108)

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(Color(red: 48 / 255, green: 140 / 255, blue: 84 / 255))
        }
    }

    private var collectedMedicinesCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Collected Medicines")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            VStack(spacing: 14) {
                ForEach(medications) { medication in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(medication.name)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text(medication.dosage)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)

                        Text(medication.schedule)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(textColor.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    )
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.96))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Important Reminders")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            reminderRow(number: "1", text: "Take medicines as prescribed by your doctor.")
            reminderRow(number: "2", text: "Store medicines in a cool dry place.")
            reminderRow(number: "3", text: "Contact your doctor if you faced side effects.")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        )
    }

    private func reminderRow(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color(red: 25 / 255, green: 102 / 255, blue: 191 / 255))
                    .frame(width: 26, height: 26)

                Text(number)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
            }

            Text(text)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var transactionCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Transaction Date")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(mutedTextColor)

                Text("March 15, 2026 at\n3:45 PM")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Amount Paid")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(mutedTextColor)

                Text("Rs. 361.75")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Transaction ID")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(mutedTextColor)

                Text("INP-2026-0315")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 25 / 255, green: 102 / 255, blue: 191 / 255))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 209 / 255, green: 230 / 255, blue: 241 / 255))
        )
    }
}

#Preview {
    CollectionCompletedView(controller: QueueController())
}
