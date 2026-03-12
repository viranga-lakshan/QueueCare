import SwiftUI

struct MedicinesReadyProgressView: View {
    @ObservedObject var controller: QueueController

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.43, green: 0.46, blue: 0.49)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)

                    readyIcon
                        .padding(.top, 42)

                    VStack(spacing: 10) {
                        Text("Your Medicines Are Ready!")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)

                        Text("Please proceed to the counter")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 26)

                    collectFromCounterCard
                        .padding(.top, 28)

                    collectionTokenCard
                        .padding(.top, 18)

                    importantInformationCard
                        .padding(.top, 22)

                    Button {
                        controller.showCollectionCompleted()
                    } label: {
                        Text("View Instructions")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(brandColor)
                                    .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 28)
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

    private var readyIcon: some View {
        ZStack {
            Circle()
                .fill(Color(red: 186 / 255, green: 220 / 255, blue: 189 / 255))
                .frame(width: 96, height: 96)

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color(red: 48 / 255, green: 140 / 255, blue: 84 / 255))
        }
    }

    private var collectFromCounterCard: some View {
        VStack(spacing: 16) {
            Text("Collect from Counter")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(red: 183 / 255, green: 216 / 255, blue: 188 / 255))
                    .frame(height: 80)

                VStack(spacing: 6) {
                    Text("03")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 43 / 255, green: 79 / 255, blue: 142 / 255))

                    Text("Count Number")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(textColor)
                }
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(red: 184 / 255, green: 199 / 255, blue: 225 / 255), lineWidth: 1)
                )
        )
    }

    private var collectionTokenCard: some View {
        VStack(spacing: 14) {
            Text("Your Collection Token")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(red: 203 / 255, green: 218 / 255, blue: 244 / 255))
                    .frame(height: 70)

                Text("P -08")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 43 / 255, green: 79 / 255, blue: 142 / 255))
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(red: 184 / 255, green: 199 / 255, blue: 225 / 255), lineWidth: 1)
                )
        )
    }

    private var importantInformationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Important Information")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(textColor)

            infoRow(text: "Show your token number at the counter")
            infoRow(text: "Pharmacist will verify your medicines")
            infoRow(text: "Ask questions about dosage if needed")
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(red: 209 / 255, green: 230 / 255, blue: 241 / 255))
        )
    }

    private func infoRow(text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(brandColor)

            Text(text)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
        }
    }
}

#Preview {
    MedicinesReadyProgressView(controller: QueueController())
}
