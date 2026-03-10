import SwiftUI

struct VerificationSuccessView: View {
    @ObservedObject var controller: QueueController
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let backgroundColor = Color(red: 0.94, green: 0.97, blue: 0.97)

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 10)

                VStack(spacing: 16) {
                    Text("Verification")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.gray.opacity(0.4))
                        .padding(.top, 32)

                    Text("Enter your verification code")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary.opacity(0.5))
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 12) {
                    ForEach(0..<5) { _ in
                        Text("2")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .frame(width: 54, height: 54)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(12)
                            .foregroundStyle(Color.gray.opacity(0.3))
                    }
                }
                .padding(.top, 38)

                Spacer()

                VStack(spacing: 20) {
                    verifiedBadge

                    VStack(spacing: 8) {
                        Text("Verified")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)

                        Text("Your phone number has been\nsuccessfully verified")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Button(action: {
                        // Navigate to main app - will be implemented next
                    }) {
                        Text("Let's Explore")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(brandColor)
                            )
                    }
                    .padding(.horizontal, 42)
                    .padding(.top, 12)
                }
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 24)

                Spacer()
                Spacer(minLength: 160)
            }

            waveFooter
        }
    }

    private var verifiedBadge: some View {
        Group {
            if let path = Bundle.main.path(forResource: "PHOTO-2026-03-10-12-35-46", ofType: "jpg", inDirectory: "Resources/Images"),
               let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } else {
                // Fallback icon if image not found
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.blue)
                }
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showVerification) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(red: 0.24, green: 0.24, blue: 0.26))
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            }

            Spacer()
        }
        .padding(.horizontal, 18)
    }

    private var waveFooter: some View {
        VStack(spacing: 0) {
            WaveShape()
                .fill(brandColor.opacity(0.3))
                .frame(height: 120)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(brandColor.opacity(0.3))
                        .frame(height: 60)
                }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

private struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.45))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.38),
            control1: CGPoint(x: rect.width * 0.08, y: rect.height * 0.22),
            control2: CGPoint(x: rect.width * 0.17, y: rect.height * 0.58)
        )
        path.addCurve(
            to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.42),
            control1: CGPoint(x: rect.width * 0.33, y: rect.height * 0.18),
            control2: CGPoint(x: rect.width * 0.42, y: rect.height * 0.62)
        )
        path.addCurve(
            to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.38),
            control1: CGPoint(x: rect.width * 0.58, y: rect.height * 0.22),
            control2: CGPoint(x: rect.width * 0.67, y: rect.height * 0.58)
        )
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.42),
            control1: CGPoint(x: rect.width * 0.83, y: rect.height * 0.18),
            control2: CGPoint(x: rect.width * 0.92, y: rect.height * 0.62)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    VerificationSuccessView(controller: QueueController())
}
