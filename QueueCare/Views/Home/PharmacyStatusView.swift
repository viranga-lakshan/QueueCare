import SwiftUI

struct PharmacyStatusView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var pharmacyController: PharmacyController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.42, green: 0.45, blue: 0.48)
    private let iconBlue = Color(red: 43 / 255, green: 79 / 255, blue: 142 / 255)
    private let statusCardColor = Color(red: 166 / 255, green: 193 / 255, blue: 234 / 255)

    private var status: PharmacyStatus {
        pharmacyController.status
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)

                    pharmacyIcon
                        .padding(.top, 46)

                    VStack(spacing: 14) {
                        Text(status.heading)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                            .multilineTextAlignment(.center)

                        Text(status.subtitle)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 28)

                    currentStatusCard
                        .padding(.top, 26)

                    prescribedMedicinesCard
                        .padding(.top, 28)

                    Button {
                        pharmacyController.loadMockStatus()
                    } label: {
                        HStack(spacing: 12) {
                            Text(status.buttonTitle)
                                .font(.system(size: 21, weight: .bold, design: .rounded))

                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 20)
                    .padding(.bottom, 36)
                }
                .padding(.horizontal, 30)
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

    private var pharmacyIcon: some View {
        ZStack {
            Circle()
                .fill(Color(red: 189 / 255, green: 215 / 255, blue: 242 / 255))
                .frame(width: 108, height: 108)

            BundleResourceImage(name: "pharmacy", subdirectory: "pharmacy", fallbackSystemName: "doc.text.fill")
                .frame(width: 44, height: 44)
        }
    }

    private var currentStatusCard: some View {
        HStack(spacing: 18) {
            BundleResourceImage(name: "status", subdirectory: "pharmacy", fallbackSystemName: "clock.fill")
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(status.currentStatusLabel)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(iconBlue.opacity(0.9))

                Text(status.currentStatusValue)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(iconBlue)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(statusCardColor)
        )
    }

    private var prescribedMedicinesCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(status.medicationsTitle)
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)

            VStack(spacing: 14) {
                ForEach(status.medications) { medication in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(medication.name)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text(medication.dosage)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)

                        Text(medication.schedule)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(textColor.opacity(0.88))
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
        .padding(.horizontal, 14)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white.opacity(0.96))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

#Preview {
    PharmacyStatusView(controller: QueueController(), pharmacyController: PharmacyController())
}