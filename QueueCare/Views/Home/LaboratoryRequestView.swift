import SwiftUI

struct LaboratoryRequestView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let cardTint = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)

    private var request: LaboratoryRequest {
        laboratoryController.request
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 12)
                    .padding(.horizontal, 22)

                VStack(spacing: 5) {
                    Text(request.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Step \(request.currentStep) / \(request.totalSteps)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.top, 14)

                laboratoryIcon
                    .padding(.top, 18)

                VStack(spacing: 8) {
                    Text(request.heading)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("\(request.doctorName) \(request.description)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(mutedTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .lineLimit(2)
                }
                .padding(.top, 16)

                requestedTestsCard
                    .padding(.top, 16)

                Spacer(minLength: 0)

                Button(action: controller.showLaboratoryTestProgress) {
                    Text("View Test Progress")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.bottom, 20)
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
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }

    private var laboratoryIcon: some View {
        ZStack {
            Circle()
                .fill(cardTint)
                .frame(width: 70, height: 70)

            Image(systemName: "flask.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(iconBlue)
        }
    }

    private var requestedTestsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(request.cardTitle)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(mutedTextColor)

            VStack(spacing: 10) {
                ForEach(request.tests) { test in
                    HStack(spacing: 10) {
                        Image(systemName: test.icon.systemName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(iconBlue)
                            .frame(width: 22)

                        Text(test.name)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal, 22)
    }
}

#Preview {
    LaboratoryRequestView(controller: QueueController(), laboratoryController: LaboratoryController())
}