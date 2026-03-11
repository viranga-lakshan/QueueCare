import SwiftUI

struct UserSectionView: View {
    @ObservedObject var controller: QueueController

    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let backgroundColor = Color(red: 0.94, green: 0.96, blue: 0.96)
    private let textColor = Color(red: 0.12, green: 0.14, blue: 0.16)
    private let secondaryText = Color(red: 0.4, green: 0.44, blue: 0.47)
    private let mutedText = Color(red: 0.58, green: 0.6, blue: 0.62)

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    profileHeader
                    optionsCard
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
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

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar
            profileAvatar
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)

            // Name & contact
            VStack(spacing: 4) {
                if controller.userProfile.name.isEmpty {
                    Text("Welcome!")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Set up your profile to get started")
                        .font(.system(size: 14))
                        .foregroundStyle(mutedText)
                } else {
                    Text(controller.userProfile.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    if !controller.userProfile.contactNumber.isEmpty {
                        Text(controller.userProfile.contactNumber)
                            .font(.system(size: 14))
                            .foregroundStyle(secondaryText)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private var profileAvatar: some View {
        if let photo = controller.userProfile.photo {
            Image(uiImage: photo)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Circle()
                    .fill(brandColor.opacity(0.15))
                Image(systemName: "person.fill")
                    .font(.system(size: 38))
                    .foregroundStyle(brandColor.opacity(0.6))
            }
        }
    }

    // MARK: - Options Card
    private var optionsCard: some View {
        VStack(spacing: 0) {
            // Edit / Add Profile
            optionRow(
                icon: controller.userProfile.name.isEmpty ? "person.badge.plus" : "pencil.circle.fill",
                title: controller.userProfile.name.isEmpty ? "Add User Details" : "Edit Profile",
                subtitle: controller.userProfile.name.isEmpty
                    ? "Complete your profile information"
                    : "Update your personal details",
                action: controller.showProfileSetup
            )

            Divider().padding(.leading, 56)

            // Add Family Member / Patient
            optionRow(
                icon: "person.2.badge.plus",
                title: "Add Patient",
                subtitle: "Add a family member or dependent",
                action: controller.showSelectPatient
            )

            Divider().padding(.leading, 56)

            // View Patients
            if !controller.selectablePatients.isEmpty {
                optionRow(
                    icon: "person.2.fill",
                    title: "My Patients",
                    subtitle: "\(controller.selectablePatients.count) patient\(controller.selectablePatients.count == 1 ? "" : "s") added",
                    action: controller.showSelectPatient
                )

                Divider().padding(.leading, 56)
            }

            // Settings placeholder
            optionRow(
                icon: "gearshape.fill",
                title: "Settings",
                subtitle: "App preferences and notifications",
                action: {}
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    private func optionRow(
        icon: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(brandColor)
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(brandColor.opacity(0.1))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(mutedText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(mutedText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UserSectionView(controller: QueueController())
}
