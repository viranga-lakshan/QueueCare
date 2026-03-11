import SwiftUI

struct DashboardView: View {
    @ObservedObject var controller: QueueController

    // MARK: - Design Tokens
    private let backgroundColor = Color(red: 0.94, green: 0.96, blue: 0.96)
    private let cardBackground = Color.white
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let primaryBlue = Color(red: 67 / 255, green: 114 / 255, blue: 204 / 255)
    private let actionBlue = Color(red: 91 / 255, green: 150 / 255, blue: 225 / 255)
    private let textColor = Color(red: 0.12, green: 0.14, blue: 0.16)
    private let secondaryText = Color(red: 0.4, green: 0.44, blue: 0.47)
    private let mutedText = Color(red: 0.58, green: 0.6, blue: 0.62)
    private let warningYellow = Color(red: 240 / 255, green: 183 / 255, blue: 53 / 255)

    // Shortcut card colors matching Figma
    private let bookDoctorColor = Color(red: 110 / 255, green: 164 / 255, blue: 225 / 255)
    private let labColor = Color(red: 225 / 255, green: 194 / 255, blue: 91 / 255)
    private let pharmacyColor = Color(red: 121 / 255, green: 195 / 255, blue: 160 / 255)
    private let queueStatusColor = Color(red: 118 / 255, green: 182 / 255, blue: 196 / 255)

    private var dashboard: DashboardModel { controller.dashboard }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    headerCard
                    shortcutGrid
                    currentVisitCard
                    nextStepCard
                    updatesCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(
                selectedTab: controller.selectedDashboardTab,
                accentColor: brandColor
            ) { tab in
                controller.selectDashboardTab(tab)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .background(
                backgroundColor.opacity(0.98)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: -2)
            )
        }
    }

    // MARK: - Header Card
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Greeting row
            HStack(alignment: .center) {
                Text("Hello, \(displayName),")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer()

                avatarView
            }

            // Patient selector row
            HStack(spacing: 12) {
                patientDropdown

                Spacer()

                addPatientButton
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(cardSurface)
    }

    private var displayName: String {
        controller.userProfile.name.isEmpty ? dashboard.patientName : controller.userProfile.name
    }

    private var avatarView: some View {
        Group {
            if let photo = controller.userProfile.photo {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
            } else {
                BundleResourceImage(name: dashboard.avatarImageName, fallbackSystemName: "person.crop.circle.fill")
            }
        }
        .frame(width: 42, height: 42)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2.5))
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
    }

    private var patientDropdown: some View {
        Menu {
            ForEach(controller.availableChildren, id: \.self) { child in
                Button(child) { controller.selectChild(named: child) }
            }
        } label: {
            HStack(spacing: 8) {
                let isPatient = controller.selectablePatients.contains { $0.name == controller.selectedChildName }
                Text("\(isPatient ? "Patient" : "Child"): \(controller.selectedChildName)")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(textColor)

                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(secondaryText)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
        }
    }

    private var addPatientButton: some View {
        Button(action: controller.showSelectPatient) {
            HStack(spacing: 6) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 13, weight: .semibold))

                Text("Add patient")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
            }
            .foregroundStyle(secondaryText)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Shortcut Grid
    private var shortcutGrid: some View {
        HStack(spacing: 10) {
            shortcutCard(
                title: "Book\nDoctor",
                imageName: "doctor",
                color: bookDoctorColor,
                action: { controller.handleDashboardShortcut(dashboard.shortcuts[0]) }
            )

            shortcutCard(
                title: "Lab\nAppointment",
                imageName: "lab",
                color: labColor,
                action: { controller.handleDashboardShortcut(dashboard.shortcuts[1]) }
            )

            shortcutCard(
                title: "Pharmacy",
                imageName: "pharmacy",
                color: pharmacyColor,
                action: { controller.handleDashboardShortcut(dashboard.shortcuts[2]) }
            )

            shortcutCard(
                title: "My Queue/\nStatus",
                imageName: "queue",
                color: queueStatusColor,
                action: { controller.handleDashboardShortcut(dashboard.shortcuts[3]) }
            )
        }
    }

    private func shortcutCard(title: String, imageName: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                BundleResourceImage(name: imageName, subdirectory: "dashboard", fallbackSystemName: "cross.case")
                    .frame(width: 44, height: 44)

                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.35), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Current Visit Card
    private var currentVisitCard: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Current visit")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(primaryBlue)

            // Content
            VStack(alignment: .leading, spacing: 14) {
                Text(dashboard.currentVisit.departmentName)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Divider().background(Color.black.opacity(0.06))

                // Metrics grid
                VStack(spacing: 12) {
                    HStack {
                        metricItem(label: "Token:", value: dashboard.currentVisit.tokenLabel, alignment: .leading)
                        Spacer()
                        metricItem(label: "Now serving:", value: dashboard.currentVisit.servingLabel, alignment: .trailing)
                    }

                    HStack {
                        metricItem(label: "People ahead:", value: String(format: "%02d", dashboard.currentVisit.peopleAhead), alignment: .leading)
                        Spacer()
                        metricItem(label: "ETA:", value: dashboard.currentVisit.etaText, alignment: .trailing)
                    }
                }

                // Action buttons
                HStack(spacing: 10) {
                    visitButton(title: "View queue", icon: nil, filled: true) {
                        controller.selectDashboardTab(.queue)
                    }

                    visitButton(title: "Direction", icon: "location.north.fill", filled: false) {}

                    visitButton(title: "Call help", icon: "phone.fill", filled: false) {}
                }
                .padding(.top, 4)
            }
            .padding(16)
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
    }

    private func metricItem(label: String, value: String, alignment: HorizontalAlignment) -> some View {
        HStack(spacing: 4) {
            if alignment == .leading {
                Text(label)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(secondaryText)
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
            } else {
                Text(label)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(secondaryText)
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
            }
        }
    }

    private func visitButton(title: String, icon: String?, filled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(filled ? .white : textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(filled ? actionBlue : Color.white)
            )
            .overlay {
                if !filled {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                }
            }
            .shadow(color: filled ? actionBlue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Next Step Card
    private var nextStepCard: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(dashboard.flow.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(brandColor)

            // Content
            VStack(spacing: 18) {
                // Progress steps
                HStack(spacing: 0) {
                    ForEach(Array(dashboard.flow.steps.enumerated()), id: \.element.id) { index, step in
                        stepIndicator(step: step)

                        if index < dashboard.flow.steps.count - 1 {
                            stepConnector(completed: step.state == .completed)
                        }
                    }
                }
                .padding(.horizontal, 8)

                // Continue button
                Button {
                    controller.selectDashboardTab(.progress)
                } label: {
                    Text(dashboard.flow.buttonTitle)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.35), radius: 6, x: 0, y: 3)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
    }

    private func stepIndicator(step: DashboardFlowStep) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(stepBackgroundColor(for: step.state))
                    .frame(width: 24, height: 24)

                switch step.state {
                case .completed:
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                case .current:
                    Circle()
                        .stroke(Color.black, lineWidth: 2.5)
                        .frame(width: 24, height: 24)
                    Circle()
                        .fill(Color.black)
                        .frame(width: 10, height: 10)
                case .upcoming:
                    EmptyView()
                }
            }

            Text(step.title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(step.state == .upcoming ? mutedText : textColor)
        }
    }

    private func stepConnector(completed: Bool) -> some View {
        Rectangle()
            .fill(completed ? brandColor : Color.black.opacity(0.12))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .offset(y: -12)
    }

    private func stepBackgroundColor(for state: DashboardFlowStepState) -> Color {
        switch state {
        case .completed: return brandColor
        case .current: return .clear
        case .upcoming: return Color.black.opacity(0.12)
        }
    }

    // MARK: - Updates Card
    private var updatesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Updates")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

            Divider().padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(Array(dashboard.updates.enumerated()), id: \.element.id) { index, update in
                    updateRow(update: update)

                    if index < dashboard.updates.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .background(cardSurface)
    }

    private func updateRow(update: DashboardUpdate) -> some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(update.icon == .confirmed ? brandColor : warningYellow)
                .frame(width: 20)

            // Title
            Text(update.title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)

            // Action button
            Button {
                if let destination = update.actionDestination {
                    controller.selectDashboardTab(destination)
                }
            } label: {
                Text(update.actionTitle)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(
                        Capsule(style: .continuous)
                            .fill(actionBlue)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: - Shared Components
    private var cardSurface: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    DashboardView(controller: QueueController())
}
