import SwiftUI

struct DepartmentSelectionView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.36, green: 0.39, blue: 0.41)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 12)

                VStack(spacing: 10) {
                    Text("Select Department")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Select the medical department for\nyour consultation")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 18)

                VStack(spacing: 14) {
                    ForEach(controller.departmentOptions) { option in
                        departmentCard(for: option)
                    }
                }
                .padding(.top, 24)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
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

    private func departmentCard(for option: DepartmentOption) -> some View {
        Button {
            controller.showBookAppointment(for: option)
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(iconBackgroundColor(for: option.theme))
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)

                    Image(systemName: option.sfSymbol)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                }

                Text(option.title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .frame(height: 92)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
    }

    private func iconBackgroundColor(for theme: DepartmentAccentTheme) -> LinearGradient {
        switch theme {
        case .blue:
            return LinearGradient(colors: [Color(red: 97 / 255, green: 102 / 255, blue: 241 / 255), Color(red: 74 / 255, green: 95 / 255, blue: 225 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .purple:
            return LinearGradient(colors: [Color(red: 202 / 255, green: 104 / 255, blue: 245 / 255), Color(red: 174 / 255, green: 87 / 255, blue: 230 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .coral:
            return LinearGradient(colors: [Color(red: 0 / 255, green: 184 / 255, blue: 212 / 255), Color(red: 0 / 255, green: 150 / 255, blue: 136 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

#Preview {
    DepartmentSelectionView(controller: QueueController())
}