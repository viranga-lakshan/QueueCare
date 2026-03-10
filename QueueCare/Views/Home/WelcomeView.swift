import SwiftUI

struct WelcomeView: View {
    @ObservedObject var controller: QueueController
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)

    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.97, blue: 0.97)
                .ignoresSafeArea()

            decorativeBackground

            VStack(spacing: 28) {
                Spacer(minLength: 12)

                heroSection

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(controller.onboardingFeatures) { feature in
                        WelcomeFeatureRow(feature: feature)
                    }
                }
                .padding(.horizontal, 10)

                Spacer()

                Button(action: controller.showRegistration) {
                    Text("Get started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(brandColor)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
        }
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            WelcomeHeroView(imageName: "Ellipse 2", accentColor: brandColor)

            Text("M Clinic")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
        }
    }

    private var decorativeBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(brandColor.opacity(0.65))
                .frame(width: 110, height: 110)
                .rotationEffect(.degrees(12))
                .offset(x: 158, y: -352)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(brandColor.opacity(0.72))
                .frame(width: 96, height: 96)
                .rotationEffect(.degrees(4))
                .offset(x: -168, y: 354)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeView(controller: QueueController())
}
