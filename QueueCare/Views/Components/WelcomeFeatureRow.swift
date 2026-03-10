import SwiftUI

struct WelcomeFeatureRow: View {
    let feature: OnboardingFeature
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: feature.iconName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(brandColor)
                .frame(width: 24, height: 24)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.black)
                Text(feature.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

#Preview {
    WelcomeFeatureRow(
        feature: OnboardingFeature(
            iconName: "clock.arrow.circlepath",
            title: "Real-Time Queue Updates",
            subtitle: "Know exactly how long you will wait"
        )
    )
    .padding()
}
