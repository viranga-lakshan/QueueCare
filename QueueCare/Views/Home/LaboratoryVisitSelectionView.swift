import SwiftUI

struct LaboratoryVisitSelectionView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let cardTint = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)

    private var selection: LaboratoryVisitSelection {
        laboratoryController.visitSelection
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 18)
                    .padding(.horizontal, 22)

                VStack(spacing: 6) {
                    Text(selection.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Step \(selection.currentStep) / \(selection.totalSteps)")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.top, 24)

                VStack(spacing: 22) {
                    ForEach(selection.options) { option in
                        visitOptionCard(option)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 42)

                Spacer(minLength: 0)

                Button {
                    if laboratoryController.selectedVisitOptionID == .inpatient {
                        controller.showLaboratoryInpatientStatus()
                    } else {
                        controller.showLaboratoryRequest()
                    }
                } label: {
                    Text(selection.buttonTitle)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.2), radius: 8, x: 0, y: 5)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.bottom, 28)
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
            Button(action: controller.showDepartmentSelection) {
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

    private func visitOptionCard(_ option: LaboratoryVisitOption) -> some View {
        let isSelected = laboratoryController.selectedVisitOptionID == option.id

        return Button {
            laboratoryController.selectVisitOption(option.id)
        } label: {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: option.icon.systemName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(option.isEnabled ? iconBlue : mutedTextColor.opacity(0.45))
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 6) {
                    Text(option.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(option.isEnabled ? textColor : mutedTextColor.opacity(0.55))
                        .multilineTextAlignment(.leading)

                    Text(option.subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(option.isEnabled ? mutedTextColor : mutedTextColor.opacity(0.45))
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                ZStack {
                    Circle()
                        .stroke(option.isEnabled ? iconBlue.opacity(0.6) : mutedTextColor.opacity(0.35), lineWidth: 1.5)
                        .frame(width: 20, height: 20)

                    if isSelected && option.isEnabled {
                        Circle()
                            .fill(iconBlue)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 92)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(cardTint.opacity(option.isEnabled ? 1 : 0.75))
            )
            .opacity(option.isEnabled ? 1 : 0.65)
        }
        .buttonStyle(.plain)
        .disabled(!option.isEnabled)
    }
}

#Preview {
    LaboratoryVisitSelectionView(controller: QueueController(), laboratoryController: LaboratoryController())
}