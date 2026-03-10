import SwiftUI

struct DashboardView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.46, green: 0.48, blue: 0.5)

    private var dashboard: DashboardModel {
        controller.dashboard
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    headerSection
                    shortcutSection
                    currentVisitSection
                    nextStepSection
                    updatesSection
                }
                .padding(.horizontal, 10)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(selectedTab: controller.selectedDashboardTab, accentColor: brandColor) { tab in
                controller.selectDashboardTab(tab)
            }
                .padding(.horizontal, 8)
                .padding(.top, 8)
                .background(backgroundColor.opacity(0.97))
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Text("Hello, \(dashboard.patientName),")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer(minLength: 0)

                avatarView
            }

            HStack(spacing: 10) {
                Menu {
                    ForEach(controller.availableChildren, id: \.self) { child in
                        Button(child) {
                            controller.selectChild(named: child)
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Child: \(controller.selectedChildName)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(textColor)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                }

                Spacer(minLength: 0)

                Button(action: controller.showRegistration) {
                    HStack(spacing: 7) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 13, weight: .semibold))

                        Text("Add patient")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(textColor)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var avatarView: some View {
        BundleResourceImage(name: dashboard.avatarImageName, fallbackSystemName: "person.crop.circle.fill")
            .frame(width: 34, height: 34)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }

    private var shortcutSection: some View {
        HStack(spacing: 10) {
            ForEach(dashboard.shortcuts) { shortcut in
                Button {
                    controller.handleDashboardShortcut(shortcut)
                } label: {
                    VStack(spacing: 8) {
                        Spacer(minLength: 0)

                        BundleResourceImage(name: shortcut.imageName, subdirectory: "dashboard", fallbackSystemName: "cross.case")
                            .frame(width: 38, height: 38)

                        Text(shortcut.title)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 86)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(shortcutGradient(for: shortcut.theme))
                    )
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 5)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var currentVisitSection: some View {
        VStack(spacing: 0) {
            sectionHeader(title: "Current visit", color: Color(red: 67 / 255, green: 114 / 255, blue: 204 / 255))

            VStack(alignment: .leading, spacing: 10) {
                Text(dashboard.currentVisit.departmentName)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)

                Divider()

                HStack(alignment: .top) {
                    metricColumn(title: "Token", value: dashboard.currentVisit.tokenLabel, alignment: .leading)
                    Spacer(minLength: 16)
                    metricColumn(title: "Now serving", value: dashboard.currentVisit.servingLabel, alignment: .trailing)
                }

                HStack(alignment: .top) {
                    metricColumn(title: "People ahead", value: String(format: "%02d", dashboard.currentVisit.peopleAhead), alignment: .leading)
                    Spacer(minLength: 16)
                    metricColumn(title: "ETA", value: dashboard.currentVisit.etaText, alignment: .trailing)
                }

                HStack(spacing: 8) {
                    visitActionButton(title: "View queue", systemImage: nil, isFilled: true) {
                        controller.selectDashboardTab(.queue)
                    }

                    visitActionButton(title: "Direction", systemImage: "location.north.fill", isFilled: false) {
                        controller.selectDashboardTab(.map)
                    }

                    visitActionButton(title: "Call help", systemImage: "phone.fill", isFilled: false) {
                    }
                }
                .padding(.top, 4)
            }
            .padding(12)
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

    private var nextStepSection: some View {
        VStack(spacing: 0) {
            sectionHeader(title: dashboard.flow.title, color: brandColor)

            VStack(spacing: 14) {
                HStack(spacing: 10) {
                    ForEach(dashboard.flow.steps) { step in
                        flowStepView(step)
                    }
                }

                Button {
                    controller.selectDashboardTab(.progress)
                } label: {
                    Text(dashboard.flow.buttonTitle)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(LinearGradient(colors: [brandColor.opacity(0.95), brandColor.opacity(0.78)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

    private func flowStepView(_ step: DashboardFlowStep) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(stepFillColor(for: step.state))
                    .frame(width: 18, height: 18)

                if step.state == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                } else if step.state == .current {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 18, height: 18)

                    Circle()
                        .fill(Color.black)
                        .frame(width: 8, height: 8)
                }
            }

            Text(step.title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }

    private var updatesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Updates")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            VStack(spacing: 12) {
                ForEach(dashboard.updates) { update in
                    HStack(spacing: 10) {
                        updateIcon(for: update.icon)

                        Text(update.title)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(textColor)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            if let destination = update.actionDestination {
                                controller.selectDashboardTab(destination)
                            }
                        } label: {
                            Text(update.actionTitle)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color(red: 91 / 255, green: 150 / 255, blue: 225 / 255))
                                )
                        }
                        .buttonStyle(.plain)
                    }

                    if update.id != dashboard.updates.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }

    private func updateIcon(for icon: DashboardUpdateIcon) -> some View {
        Image(systemName: icon == .confirmed ? "checkmark" : "checkmark.circle")
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(icon == .confirmed ? brandColor : Color(red: 240 / 255, green: 183 / 255, blue: 53 / 255))
            .frame(width: 18)
    }

    private func sectionHeader(title: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color)
    }

    private func metricColumn(title: String, value: String, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 3) {
            Text(title)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(mutedTextColor)

            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
    }

    private func visitActionButton(title: String, systemImage: String?, isFilled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 12, weight: .semibold))
                }

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(isFilled ? .white : textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isFilled ? Color(red: 80 / 255, green: 143 / 255, blue: 221 / 255) : .white)
            )
            .overlay {
                if !isFilled {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                }
            }
            .shadow(color: isFilled ? .clear : .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func shortcutGradient(for theme: DashboardAccentTheme) -> LinearGradient {
        switch theme {
        case .blue:
            return LinearGradient(colors: [Color(red: 110 / 255, green: 164 / 255, blue: 225 / 255), Color(red: 81 / 255, green: 132 / 255, blue: 210 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .sky:
            return LinearGradient(colors: [Color(red: 111 / 255, green: 190 / 255, blue: 236 / 255), Color(red: 73 / 255, green: 146 / 255, blue: 223 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .mint:
            return LinearGradient(colors: [Color(red: 121 / 255, green: 204 / 255, blue: 171 / 255), Color(red: 79 / 255, green: 177 / 255, blue: 145 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .indigo:
            return LinearGradient(colors: [Color(red: 103 / 255, green: 164 / 255, blue: 229 / 255), Color(red: 76 / 255, green: 124 / 255, blue: 208 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private func stepFillColor(for state: DashboardFlowStepState) -> Color {
        switch state {
        case .completed:
            return brandColor
        case .current:
            return .white
        case .upcoming:
            return Color.black.opacity(0.14)
        }
    }
}

#Preview {
    DashboardView(controller: QueueController())
}