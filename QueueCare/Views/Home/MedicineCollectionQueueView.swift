import SwiftUI

struct MedicineCollectionQueueView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.43, green: 0.46, blue: 0.49)
    private let cardBorderColor = Color(red: 184 / 255, green: 199 / 255, blue: 225 / 255)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)

                    queueIcon
                        .padding(.top, 40)

                    VStack(spacing: 10) {
                        Text("Medicine Collection Queue")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Please wait for your turn")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 26)

                    collectionTokenCard
                        .padding(.top, 30)

                    quoteStatusCard
                        .padding(.top, 22)

                    statusStrip
                        .padding(.top, 22)
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 28)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                controller.completeMedicineQueueAndShowDashboard()
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
                .fill(Color(red: 245 / 255, green: 196 / 255, blue: 193 / 255))
                .frame(width: 96, height: 96)

            BundleResourceImage(name: "pharmacy", subdirectory: "pharmacy", fallbackSystemName: "doc.text.fill")
                .frame(width: 40, height: 40)
        }
    }

    private var collectionTokenCard: some View {
        VStack(spacing: 14) {
            Text("Your Collection Token")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 46 / 255, green: 80 / 255, blue: 150 / 255))

            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(red: 203 / 255, green: 218 / 255, blue: 244 / 255))
                    .frame(height: 96)

                VStack(spacing: 6) {
                    Text("P")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 43 / 255, green: 79 / 255, blue: 142 / 255))

                    Text("08")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 43 / 255, green: 79 / 255, blue: 142 / 255))
                }
            }

            Text("Please remember this number")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(mutedTextColor)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(cardBorderColor, lineWidth: 1)
                )
        )
    }

    private var quoteStatusCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Queue Status")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            VStack(spacing: 10) {
                statusRow(title: "Now Serving", value: "P-05", iconColor: Color(red: 163 / 255, green: 210 / 255, blue: 177 / 255))
                statusRow(title: "People Ahead", value: "3", iconColor: Color(red: 250 / 255, green: 220 / 255, blue: 214 / 255))
                statusRow(title: "Estimated Wait Time", value: "8 mins", iconColor: Color(red: 198 / 255, green: 223 / 255, blue: 200 / 255))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(cardBorderColor, lineWidth: 1)
                )
        )
    }

    private func statusRow(title: String, value: String, iconColor: Color) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(iconColor)
                .frame(width: 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(mutedTextColor)

                Text(value)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(iconColor.opacity(0.35))
        )
    }

    private var statusStrip: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Status")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 156 / 255, green: 91 / 255, blue: 81 / 255))

                Text("Preparing your medicine")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 156 / 255, green: 91 / 255, blue: 81 / 255))
            }

            Spacer(minLength: 0)

            BundleResourceImage(name: "status", subdirectory: "pharmacy", fallbackSystemName: "pills.fill")
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(red: 230 / 255, green: 190 / 255, blue: 186 / 255), lineWidth: 1)
                )
        )
    }
}

#Preview {
    MedicineCollectionQueueView(controller: QueueController())
}
