import SwiftUI

struct LiveQueueView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor     = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor      = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)

    private var queue: LiveQueueModel { controller.liveQueue }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 18)
                    .padding(.horizontal, 22)

                Spacer()

                // ── Queue card ──
                VStack(spacing: 28) {

                    // Department badge
                    Text(queue.departmentName)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(brandColor)
                        )

                    // Queue number ring
                    ZStack {
                        Circle()
                            .stroke(brandColor.opacity(0.15), lineWidth: 18)
                            .frame(width: 200, height: 200)

                        Circle()
                            .stroke(brandColor, lineWidth: 6)
                            .frame(width: 200, height: 200)

                        VStack(spacing: 6) {
                            Text("Your Queue No.")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(mutedTextColor)

                            Text(queue.queueNumber)
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundStyle(textColor)
                        }
                    }

                    // Wait time
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(brandColor)

                        Text(queue.estimatedWaitLabel)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )

                    // Info note
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(brandColor)

                        Text("You have been added to the live queue. Please proceed to the department when your number is called.")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(brandColor.opacity(0.08))
                    )
                    .padding(.horizontal, 22)
                }

                Spacer()

                // Exit button
                Button(action: controller.showDashboard) {
                    Text("Confirm")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.bottom, 36)
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
            Button(action: controller.showBookAppointmentBack) {
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
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
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
}

#Preview {
    LiveQueueView(controller: QueueController())
}
