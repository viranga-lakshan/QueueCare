import SwiftUI

struct VerificationSuccessView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var phoneAuthController: PhoneAuthController
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

                    Text(phoneAuthController.currentPhoneNumber.isEmpty ? "Phone verified successfully" : "Code confirmed for\n\(phoneAuthController.maskedPhoneNumber)")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 12) {
                    ForEach(0..<phoneAuthController.otpDigits, id: \.self) { index in
                        Text(verifiedDigit(at: index))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .frame(width: 54, height: 54)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(12)
                            .foregroundStyle(Color.gray.opacity(0.3))
                    }
                }
                .padding(.top, 38)

                Spacer(minLength: 0)

                VStack(spacing: 18) {
                    verifiedBadge

                    VStack(spacing: 8) {
                        Text("Verified")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)

                        Text(successMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 26)

                Button(action: controller.showDashboard) {
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
                .padding(.bottom, 28)

                Spacer(minLength: 140)
            }

            RegistrationWaveFooter(color: brandColor)
                .ignoresSafeArea(edges: .bottom)
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

    private var successMessage: String {
        if phoneAuthController.currentPhoneNumber.isEmpty {
            return "Your phone number has been\nsuccessfully verified"
        }

        return "\(phoneAuthController.maskedPhoneNumber) has been\nsuccessfully verified"
    }

    private func verifiedDigit(at index: Int) -> String {
        guard phoneAuthController.lastVerifiedCode.count > index else { return "•" }
        let startIndex = phoneAuthController.lastVerifiedCode.index(phoneAuthController.lastVerifiedCode.startIndex, offsetBy: index)
        let endIndex = phoneAuthController.lastVerifiedCode.index(after: startIndex)
        return String(phoneAuthController.lastVerifiedCode[startIndex..<endIndex])
    }
}

#Preview {
    VerificationSuccessView(controller: QueueController(), phoneAuthController: PhoneAuthController())
}
