import SwiftUI

struct VerificationView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var phoneAuthController: PhoneAuthController
    @State private var code = ""
    @FocusState private var focusedIndex: Int?

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
                        .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.2))
                        .padding(.top, 32)

                    Text(verificationSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 12) {
                    ForEach(0..<phoneAuthController.otpDigits, id: \.self) { index in
                        VerificationCodeInput(
                            code: $code,
                            focusedIndex: $focusedIndex,
                            index: index,
                            totalDigits: phoneAuthController.otpDigits,
                            brandColor: brandColor
                        )
                    }
                }
                .padding(.top, 48)

                if let errorMessage = phoneAuthController.errorMessage {
                    Text(errorMessage)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.top, 18)
                }

                Spacer()

                Button {
                    Task {
                        await controller.verifyOTP(code)
                    }
                } label: {
                    Group {
                        if phoneAuthController.isVerifyingCode {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Verify")
                                .font(.headline)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule(style: .continuous)
                            .fill(brandColor.opacity(canVerify ? 1 : 0.45))
                    )
                }
                .disabled(!canVerify || phoneAuthController.isVerifyingCode)
                .padding(.horizontal, 42)
                .padding(.bottom, 28)

                Spacer(minLength: 140)
            }

            RegistrationWaveFooter(color: brandColor)
        }
        .onAppear {
            code = ""
            focusedIndex = 0
        }
        .onChange(of: code) { _, _ in
            phoneAuthController.clearError()
        }
    }

    private var canVerify: Bool {
        code.filter(\.isNumber).count == phoneAuthController.otpDigits
    }

    private var verificationSubtitle: String {
        if phoneAuthController.currentPhoneNumber.isEmpty {
            return "Enter your verification code"
        }

        return "Enter the 6-digit code sent to\n\(phoneAuthController.maskedPhoneNumber)"
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showRegistration) {
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
}

#Preview {
    VerificationView(controller: QueueController(), phoneAuthController: PhoneAuthController())
}
