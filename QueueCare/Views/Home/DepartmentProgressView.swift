import SwiftUI

struct DepartmentProgressView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor     = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor      = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)

    private var hasAnyProgress: Bool {
        controller.bookDoctorProgress != nil
        || controller.labProgress != nil
        || controller.pharmacyProgressEntry != nil
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
                        Text("Progress")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Your visit status")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 22)

                    if hasAnyProgress {
                        VStack(spacing: 22) {
                            if let doc = controller.bookDoctorProgress {
                                progressSection(title: "Book Doctor", icon: "stethoscope") {
                                    bookDoctorCard(doc)
                                }
                            }
                            if let lab = controller.labProgress {
                                progressSection(title: "Lab Appointment", icon: "cross.vial.fill") {
                                    labCard(lab)
                                }
                            }
                            if let pharmacy = controller.pharmacyProgressEntry {
                                progressSection(title: "Pharmacy", icon: "pills.fill") {
                                    pharmacyCard(pharmacy)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                        .padding(.bottom, 32)
                    } else {
                        emptyState
                    }
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

    // MARK: – Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 56))
                .foregroundStyle(mutedTextColor.opacity(0.4))

            Text("No activity yet")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(mutedTextColor)

            Text("Your progress will appear here after\nyou complete a booking, lab or pharmacy flow.")
                .font(.system(size: 14))
                .foregroundStyle(mutedTextColor.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 80)
        .padding(.horizontal, 40)
    }

    // MARK: – Section wrapper

    private func progressSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            // Section header
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(brandColor)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 14, bottomLeading: 0, bottomTrailing: 0, topTrailing: 14)))

            content()
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

    // MARK: – Book Doctor card

    private func bookDoctorCard(_ doc: BookDoctorProgress) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(iconGradient(for: doc.theme))
                        .frame(width: 48, height: 48)
                    Image(systemName: doc.sfSymbol)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white)
                }
                Text(doc.departmentName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
                Spacer(minLength: 0)
                statusBadge(label: doc.status.label, for: bookDoctorBadgeColor(doc.status))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            switch doc.status {
            case .scheduled(let date, let time):
                Divider().padding(.horizontal, 16)
                HStack {
                    detailPill(icon: "calendar", text: date)
                    Spacer(minLength: 0)
                    detailPill(icon: "clock", text: time)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            case .inQueue(let token, let currentServing, let peopleAhead, let waitMin):
                Divider().padding(.horizontal, 16)
                queueDetailRow(token: token, currentServing: currentServing, peopleAhead: peopleAhead, waitMin: waitMin)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            case .completed:
                EmptyView()
            }
        }
        .background(.white)
    }

    private func bookDoctorBadgeColor(_ status: BookDoctorStatus) -> Color {
        switch status {
        case .scheduled: return .blue
        case .inQueue:   return brandColor
        case .completed: return .green
        }
    }

    // MARK: – Lab card

    private func labCard(_ lab: LabProgress) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(LinearGradient(colors: [Color(red: 97/255, green: 102/255, blue: 241/255), Color(red: 74/255, green: 95/255, blue: 225/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 48, height: 48)
                    Image(systemName: "cross.vial.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
                Text("Laboratory")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
                Spacer(minLength: 0)
                statusBadge(label: lab.status.label, for: labBadgeColor(lab.status))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            switch lab.status {
            case .scheduled:
                Divider().padding(.horizontal, 16)
                HStack {
                    detailPill(icon: "calendar", text: lab.dateLabel)
                    Spacer(minLength: 0)
                    detailPill(icon: "clock", text: lab.timeLabel)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            case .inQueue(let token, let currentServing, let peopleAhead, let waitMin):
                Divider().padding(.horizontal, 16)
                queueDetailRow(token: token, currentServing: currentServing, peopleAhead: peopleAhead, waitMin: waitMin)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            case .completed:
                EmptyView()
            }
        }
        .background(.white)
    }

    private func labBadgeColor(_ status: LabStatus) -> Color {
        switch status {
        case .scheduled: return .blue
        case .inQueue:   return brandColor
        case .completed: return .green
        }
    }

    // MARK: – Pharmacy card

    private func pharmacyCard(_ pharmacy: PharmacyProgressEntry) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(LinearGradient(colors: [Color(red: 121/255, green: 204/255, blue: 171/255), Color(red: 79/255, green: 177/255, blue: 145/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 48, height: 48)
                    Image(systemName: "pills.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
                Text("Pharmacy")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
                Spacer(minLength: 0)
                statusBadge(label: pharmacy.status.label, for: pharmacyBadgeColor(pharmacy.status))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(.white)
    }

    private func pharmacyBadgeColor(_ status: PharmacyProgressStatus) -> Color {
        switch status {
        case .preparing: return .orange
        case .inQueue:   return brandColor
        case .completed: return .green
        }
    }

    // MARK: – Shared components

    private func statusBadge(label: String, for color: Color) -> some View {
        Text(label)
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule(style: .continuous).fill(color.opacity(0.12)))
    }

    private func detailPill(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(brandColor)
            Text(text)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(mutedTextColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(brandColor.opacity(0.08)))
    }

    private func queueDetailRow(token: String, currentServing: String, peopleAhead: Int, waitMin: Int) -> some View {
        VStack(spacing: 12) {
            // Token and Current Serving row
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Your Token")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                    Text(token)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                }
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 3) {
                    Text("Now Serving")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                    Text(currentServing)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(brandColor)
                }
            }

            // People ahead and wait time row
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(brandColor)
                    Text("\\(peopleAhead) ahead")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(brandColor.opacity(0.08)))

                Spacer(minLength: 0)

                HStack(spacing: 5) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(brandColor)
                    Text("~\\(waitMin) min")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(brandColor.opacity(0.08)))
            }
        }
    }

    // MARK: – Top bar

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
            Group {
                if let photo = controller.userProfile.photo {
                    Image(uiImage: photo).resizable().scaledToFill()
                } else {
                    BundleResourceImage(name: controller.dashboard.avatarImageName, fallbackSystemName: "person.crop.circle.fill")
                }
            }
            .frame(width: 34, height: 34)
            .clipShape(Circle())
            .overlay(Circle().stroke(.white, lineWidth: 2))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }

    // MARK: – Helpers

    private func iconGradient(for theme: DepartmentAccentTheme) -> LinearGradient {
        switch theme {
        case .blue:
            return LinearGradient(colors: [Color(red: 97/255, green: 102/255, blue: 241/255), Color(red: 74/255, green: 95/255, blue: 225/255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .purple:
            return LinearGradient(colors: [Color(red: 202/255, green: 104/255, blue: 245/255), Color(red: 174/255, green: 87/255, blue: 230/255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .coral:
            return LinearGradient(colors: [Color(red: 251/255, green: 110/255, blue: 118/255), Color(red: 243/255, green: 86/255, blue: 100/255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

#Preview {
    DepartmentProgressView(controller: QueueController())
}
