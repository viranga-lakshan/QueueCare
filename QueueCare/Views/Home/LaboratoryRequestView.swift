import SwiftUI

struct LaboratoryRequestView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.43, green: 0.46, blue: 0.49)
    private let cardTint = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconBlue = Color(red: 36 / 255, green: 73 / 255, blue: 138 / 255)

    private var request: LaboratoryRequest {
        laboratoryController.request
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)

                    VStack(spacing: 8) {
                        Text(request.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Step \(request.currentStep) / \(request.totalSteps)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 26)

                    laboratoryIcon
                        .padding(.top, 44)

                    VStack(spacing: 14) {
                        Text(request.heading)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("\(request.doctorName) \(request.description)")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 34)

                    requestedTestsCard
                        .padding(.top, 34)

                    Button(action: controller.showLaboratoryVisitSelection) {
                        Text(request.buttonTitle)
                            .font(.system(size: 21, weight: .bold, design: .rounded))
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
                    .padding(.top, 56)
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

    private var laboratoryIcon: some View {
        ZStack {
            Circle()
                .fill(cardTint)
                .frame(width: 108, height: 108)

            Image(systemName: "flask.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(iconBlue)
        }
    }

    private var requestedTestsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(request.cardTitle)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.78))

            VStack(spacing: 18) {
                ForEach(request.tests) { test in
                    HStack(spacing: 16) {
                        Image(systemName: test.icon.systemName)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(iconBlue)
                            .frame(width: 28)

                        Text(test.name)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(cardTint)
        )
    }
}

#Preview {
    LaboratoryRequestView(controller: QueueController(), laboratoryController: LaboratoryController())
}