import SwiftUI

struct LaboratoryInpatientStatusView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    private let cardBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconCircle = Color(red: 180 / 255, green: 195 / 255, blue: 232 / 255)
    private let cardGreen = Color(red: 210 / 255, green: 234 / 255, blue: 210 / 255)

    private var status: LaboratoryInpatientStatus {
        laboratoryController.inpatientStatus
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)
                        .padding(.horizontal, 22)

                    VStack(spacing: 6) {
                        Text(status.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Step \(status.currentStep) / \(status.totalSteps)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 24)

                    // Document icon
                    ZStack {
                        Circle()
                            .fill(iconCircle)
                            .frame(width: 80, height: 80)

                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundStyle(iconBlue)
                    }
                    .padding(.top, 36)

                    Text(status.heading)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 18)

                    // Ordered tests card
                    VStack(alignment: .leading, spacing: 14) {
                        Text(status.orderedTestsLabel)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)

                        VStack(spacing: 10) {
                            ForEach(status.orderedTests, id: \.self) { test in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(iconBlue)
                                        .frame(width: 8, height: 8)
                                    Text(test)
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundStyle(textColor)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.white)
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(cardBlue)
                    )
                    .padding(.horizontal, 22)
                    .padding(.top, 28)

                    // Status card
                    HStack(spacing: 14) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 34, weight: .medium))
                            .foregroundStyle(brandColor)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(status.statusTitle)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(textColor)
                            Text(status.statusSubtitle)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(mutedTextColor)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(cardGreen)
                    )
                    .padding(.horizontal, 22)
                    .padding(.top, 16)

                    // Ward card
                    VStack(alignment: .leading, spacing: 6) {
                        Text(status.wardLabel)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                        Text(status.wardValue)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal, 22)
                    .padding(.top, 16)
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
            Button(action: controller.showLaboratoryVisitSelection) {
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
}

#Preview {
    LaboratoryInpatientStatusView(
        controller: QueueController(),
        laboratoryController: LaboratoryController()
    )
}
