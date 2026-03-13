import SwiftUI

struct PatientRegistrationView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var phoneAuthController: PhoneAuthController
    @State private var phoneNumberDigits = ""
    @State private var acceptedTerms = false

    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let backgroundColor = Color(red: 0.94, green: 0.97, blue: 0.97)

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                topBar
                    .padding(.top, 10)

                VStack(spacing: 18) {
                    Text("Patient Registration")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.2))
                        .padding(.top, 22)

                    Text("Please enter your details for continue *")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 26) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 2) {
                            Text("Phone Number")
                                .font(.subheadline.weight(.semibold))
                            Text("*")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.red)
                        }

                        HStack(spacing: 10) {
                            Image(systemName: "iphone")
                                .foregroundStyle(brandColor)
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 18)

                            Text(phoneAuthController.countryCode)
                                .font(.body)
                                .foregroundStyle(.secondary)

                            TextField("771234567", text: $phoneNumberDigits)
                                .keyboardType(.numberPad)
                                .textInputAutocapitalization(.never)
                                .onChange(of: phoneNumberDigits) { _, newValue in
                                    var digits = newValue.filter(\.isNumber)

                                    if digits.hasPrefix("94"), digits.count >= 11 {
                                        digits = String(digits.dropFirst(2))
                                    }

                                    if digits.hasPrefix("0"), digits.count == 10 {
                                        digits = String(digits.dropFirst())
                                    }

                                    let limited = String(digits.prefix(9))
                                    if limited != newValue {
                                        phoneNumberDigits = limited
                                    }
                                }
                        }
                        .padding(.bottom, 10)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(brandColor.opacity(0.35))
                                .frame(height: 1.5)
                        }
                    }

                    Text("Enter 9 digits after \(phoneAuthController.countryCode) (e.g. 771234567)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let errorMessage = phoneAuthController.errorMessage {
                        Text(errorMessage)
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.red)
                    }

                    Spacer(minLength: 0)

                    Toggle(isOn: $acceptedTerms) {
                        HStack(spacing: 3) {
                            Text("Accept Terms and conditions")
                                .font(.footnote.weight(.medium))
                            Text("*")
                                .font(.footnote.weight(.bold))
                                .foregroundStyle(.red)
                        }
                    }
                    .toggleStyle(CheckboxToggleStyle(tint: brandColor))
                    .padding(.bottom, 20)

                    Button {
                        Task {
                            await controller.requestOTP(for: phoneAuthController.countryCode + phoneNumberDigits)
                        }
                    } label: {
                        Group {
                            if phoneAuthController.isSendingCode {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Register")
                                    .font(.headline)
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule(style: .continuous)
                                .fill(brandColor.opacity(canRegister ? 1 : 0.45))
                        )
                    }
                    .disabled(!canRegister || phoneAuthController.isSendingCode)
                    .padding(.horizontal, 42)
                }
                .padding(.top, 50)
                .padding(.horizontal, 26)

                Spacer(minLength: 140)
            }

            RegistrationWaveFooter(color: brandColor)
        }
        .onChange(of: phoneNumberDigits) { _, _ in
            phoneAuthController.clearError()
        }
    }

    private var canRegister: Bool {
        phoneNumberDigits.count == 9 && acceptedTerms
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showWelcome) {
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

private struct CheckboxToggleStyle: ToggleStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 10) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(tint.opacity(0.7), lineWidth: 1.4)
                    .background(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(configuration.isOn ? tint.opacity(0.16) : .clear)
                    )
                    .overlay {
                        if configuration.isOn {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(tint)
                        }
                    }
                    .frame(width: 18, height: 18)
                    .padding(.top, 1)

                configuration.label
                    .foregroundStyle(Color(red: 0.24, green: 0.24, blue: 0.26))

                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PatientRegistrationView(controller: QueueController(), phoneAuthController: PhoneAuthController())
}
