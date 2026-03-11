import SwiftUI

struct NoActiveQueueView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.43, green: 0.46, blue: 0.49)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 18)

                Spacer(minLength: 0)

                queueIcon

                VStack(spacing: 10) {
                    Text("No active queue")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("You don't have any active queues right now.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Text("Start a visit or pharmacy flow to see your queue status here.")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 4)
                }
                .padding(.top, 24)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 26)
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

    private var queueIcon: some View {
        ZStack {
            Circle()
                .fill(Color(red: 210 / 255, green: 223 / 255, blue: 246 / 255))
                .frame(width: 108, height: 108)

            BundleResourceImage(name: "queue", subdirectory: "dashboard", fallbackSystemName: "clock.badge.questionmark")
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    NoActiveQueueView(controller: QueueController())
}
