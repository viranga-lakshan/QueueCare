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
                VStack(spacing: 20) {
                    headerCard
                    servicesSection
                    activeStatusSection
                    quickActionsSection
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
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 0)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -4)
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
        Button {
            controller.selectDashboardTab(.user)
        } label: {
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
        .buttonStyle(.plain)
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

    // MARK: - Services Section
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Services")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                serviceCard(
                    title: "Book Doctor Appointment",
                    subtitle: "Schedule consultation with specialists",
                    icon: "stethoscope.circle.fill",
                    color: bookDoctorColor,
                    action: { controller.handleDashboardShortcut(dashboard.shortcuts[0]) }
                )

                serviceCard(
                    title: "Lab Appointment",
                    subtitle: "Book tests and view reports",
                    icon: "cross.vial.fill",
                    color: labColor,
                    action: { controller.handleDashboardShortcut(dashboard.shortcuts[1]) }
                )

                serviceCard(
                    title: "Pharmacy",
                    subtitle: "Track prescriptions and collect medicine",
                    icon: "pill.circle.fill",
                    color: pharmacyColor,
                    action: { controller.handleDashboardShortcut(dashboard.shortcuts[2]) }
                )
            }
        }
    }

    private func serviceCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundStyle(color)
                }

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(mutedText)
                        .lineLimit(1)
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(mutedText.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Active Status Section
    private var activeStatusSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Active Visit")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)

            if let progress = controller.bookDoctorProgress {
                // Show active visit card with any status
                activeVisitCardForProgress(progress)
            } else {
                // Show empty state
                noActiveVisitCard
            }
        }
    }

    @ViewBuilder
    private func activeVisitCardForProgress(_ progress: BookDoctorProgress) -> some View {
        switch progress.status {
        case .scheduled(let dateLabel, let timeLabel):
            scheduledVisitCard(
                departmentName: progress.departmentName,
                dateLabel: dateLabel,
                timeLabel: timeLabel
            )
        case .inQueue(let token, let currentServing, let peopleAhead, let waitMin):
            inQueueVisitCard(
                departmentName: progress.departmentName,
                token: token,
                currentServing: currentServing,
                peopleAhead: peopleAhead,
                waitMin: waitMin
            )
        case .completed:
            completedVisitCard(departmentName: progress.departmentName)
        }
    }

    private var noActiveVisitCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 48))
                .foregroundStyle(mutedText.opacity(0.4))
                .padding(.top, 24)

            VStack(spacing: 6) {
                Text("No Active Visit")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)

                Text("Book a doctor appointment to see your queue status here")
                    .font(.system(size: 14))
                    .foregroundStyle(mutedText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            Button {
                controller.handleDashboardShortcut(dashboard.shortcuts[0])
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 13))
                    Text("Book Doctor")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(brandColor)
                )
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func scheduledVisitCard(
        departmentName: String,
        dateLabel: String,
        timeLabel: String
    ) -> some View {
        VStack(spacing: 0) {
            // Department header
            HStack {
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 20))
                    .foregroundStyle(brandColor)

                Text(departmentName)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer()

                Text("Scheduled")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(brandColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(brandColor.opacity(0.12))
                    )
            }
            .padding(16)

            Divider()

            // Appointment details
            HStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("Date")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(mutedText)

                    Text(dateLabel)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 1)
                    .padding(.vertical, 12)

                VStack(spacing: 6) {
                    Text("Time")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(mutedText)

                    Text(timeLabel)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)

            Divider()

            // Actions
            HStack(spacing: 12) {
                Button {
                    controller.selectDashboardTab(.progress)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13))
                        Text("View Details")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(brandColor)
                    )
                }

                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 13))
                        Text("Help")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1.5)
                    )
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func inQueueVisitCard(
        departmentName: String,
        token: String,
        currentServing: String,
        peopleAhead: Int,
        waitMin: Int
    ) -> some View {
        VStack(spacing: 0) {
            // Department header
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(primaryBlue)

                Text(departmentName)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer()

                Text("In Queue")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(primaryBlue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(primaryBlue.opacity(0.12))
                    )
            }
            .padding(16)

            Divider()

            // Queue details
            HStack(spacing: 0) {
                queueMetric(
                    label: "Your Token",
                    value: token,
                    color: textColor
                )

                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 1)
                    .padding(.vertical, 12)

                queueMetric(
                    label: "Now Serving",
                    value: currentServing,
                    color: brandColor
                )
            }
            .padding(.vertical, 12)

            Divider()

            // Wait info
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(mutedText)
                    Text("\(peopleAhead) ahead")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(secondaryText)
                }

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(mutedText)
                    Text("~\(waitMin) min")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(secondaryText)
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.03))

            Divider()

            // Actions
            HStack(spacing: 12) {
                Button {
                    controller.selectDashboardTab(.progress)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .font(.system(size: 13))
                        Text("View Queue")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(brandColor)
                    )
                }

                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 13))
                        Text("Help")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1.5)
                    )
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func completedVisitCard(departmentName: String) -> some View {
        VStack(spacing: 0) {
            // Department header
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.green)

                Text(departmentName)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Spacer()

                Text("Completed")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.green.opacity(0.12))
                    )
            }
            .padding(16)

            Divider()

            // Completion message
            VStack(spacing: 12) {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.green.opacity(0.6))
                    .padding(.top, 8)

                VStack(spacing: 4) {
                    Text("Visit Completed")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Thank you for using our services")
                        .font(.system(size: 13))
                        .foregroundStyle(mutedText)
                }
            }
            .padding(.vertical, 20)

            Divider()

            // Actions
            HStack(spacing: 12) {
                Button {
                    controller.selectDashboardTab(.progress)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13))
                        Text("View History")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(brandColor)
                    )
                }

                Button {
                    controller.handleDashboardShortcut(dashboard.shortcuts[0])
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 13))
                        Text("Book Again")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1.5)
                    )
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func queueMetric(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(mutedText)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)

            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    quickActionCard(
                        icon: "calendar.badge.plus",
                        title: "My\nAppointments",
                        color: Color(red: 91 / 255, green: 150 / 255, blue: 225 / 255),
                        action: { controller.selectDashboardTab(.progress) }
                    )

                    quickActionCard(
                        icon: "doc.text.fill",
                        title: "Medical\nRecords",
                        color: Color(red: 240 / 255, green: 149 / 255, blue: 107 / 255),
                        action: { controller.showMedicalRecords() }
                    )
                }

                HStack(spacing: 10) {
                    quickActionCard(
                        icon: "map.fill",
                        title: "Hospital\nNavigation",
                        color: Color(red: 147 / 255, green: 112 / 255, blue: 219 / 255),
                        action: { controller.showHospitalNavigation() }
                    )

                    quickActionCard(
                        icon: "questionmark.circle.fill",
                        title: "Help &\nSupport",
                        color: Color(red: 121 / 255, green: 195 / 255, blue: 160 / 255),
                        action: { controller.showHelpSupport() }
                    )
                }
            }
        }
    }

    private func quickActionCard(
        icon: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                    .frame(width: 40)

                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Shortcut Grid (Legacy - Removed)
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
