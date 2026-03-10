import Foundation
import Combine
import FirebaseAuth

#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class PhoneAuthController: ObservableObject {
    static let verificationIDKey = "authVerificationID"
    private static let defaultCountryCode = "+94"

    let otpDigits = 6

    @Published private(set) var isSendingCode = false
    @Published private(set) var isVerifyingCode = false
    @Published private(set) var currentPhoneNumber = ""
    @Published private(set) var lastVerifiedCode = ""
    @Published var errorMessage: String?

    func clearError() {
        errorMessage = nil
    }

    func sendOTP(to rawPhoneNumber: String) async -> Bool {
        clearError()

        let normalizedPhoneNumber = normalizePhoneNumber(rawPhoneNumber)
        guard isValid(phoneNumber: normalizedPhoneNumber) else {
            errorMessage = PhoneAuthError.invalidPhoneNumber.errorDescription
            return false
        }

        isSendingCode = true
        defer { isSendingCode = false }

        do {
            let verificationID = try await requestVerificationID(for: normalizedPhoneNumber)
            UserDefaults.standard.set(verificationID, forKey: Self.verificationIDKey)
            currentPhoneNumber = normalizedPhoneNumber
            lastVerifiedCode = ""
            return true
        } catch {
            errorMessage = friendlyErrorMessage(for: error)
            return false
        }
    }

    func verifyOTP(_ rawCode: String) async -> Bool {
        clearError()

        let verificationCode = rawCode.filter(\.isNumber)
        guard verificationCode.count == otpDigits else {
            errorMessage = PhoneAuthError.invalidOTP.errorDescription
            return false
        }

        guard let verificationID = UserDefaults.standard.string(forKey: Self.verificationIDKey),
              !verificationID.isEmpty else {
            errorMessage = PhoneAuthError.missingVerificationID.errorDescription
            return false
        }

        isVerifyingCode = true
        defer { isVerifyingCode = false }

        do {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            _ = try await signIn(with: credential)
            lastVerifiedCode = verificationCode
            return true
        } catch {
            errorMessage = friendlyErrorMessage(for: error)
            return false
        }
    }

    var maskedPhoneNumber: String {
        guard currentPhoneNumber.count > 6 else { return currentPhoneNumber }

        let prefix = currentPhoneNumber.prefix(4)
        let suffix = currentPhoneNumber.suffix(3)
        return "\(prefix)••••\(suffix)"
    }

    private func requestVerificationID(for phoneNumber: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let verificationID else {
                    continuation.resume(throwing: PhoneAuthError.missingVerificationID)
                    return
                }

                continuation.resume(returning: verificationID)
            }
        }
    }

    private func signIn(with credential: PhoneAuthCredential) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: credential) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let result else {
                    continuation.resume(throwing: PhoneAuthError.authenticationFailed)
                    return
                }

                continuation.resume(returning: result)
            }
        }
    }

    private func normalizePhoneNumber(_ rawPhoneNumber: String) -> String {
        let trimmed = rawPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleaned = trimmed.filter { $0.isNumber || $0 == "+" }

        if cleaned.hasPrefix("+") {
            return "+" + cleaned.dropFirst().filter(\.isNumber)
        }

        let digits = cleaned.filter(\.isNumber)

        if digits.hasPrefix("94") {
            return "+\(digits)"
        }

        if digits.hasPrefix("0"), digits.count == 10 {
            return Self.defaultCountryCode + String(digits.dropFirst())
        }

        if digits.hasPrefix("7"), digits.count == 9 {
            return Self.defaultCountryCode + digits
        }

        return "+\(digits)"
    }

    private func isValid(phoneNumber: String) -> Bool {
        let pattern = "^\\+[1-9][0-9]{7,14}$"
        return phoneNumber.range(of: pattern, options: .regularExpression) != nil
    }

    private func friendlyErrorMessage(for error: Error) -> String {
        let nsError = error as NSError

        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidPhoneNumber:
                return "That phone number is invalid. Use +94771234567 or 0771234567."
            case .quotaExceeded:
                return "SMS quota has been exceeded for this Firebase project. Try again later or use a Firebase test phone number."
            case .captchaCheckFailed:
                return "App verification failed. Check the Firebase URL scheme, API key restrictions, and reCAPTCHA setup."
            case .appNotAuthorized:
                return "This app is not authorized to use Firebase Authentication. Check your bundle ID, APNs setup, and Firebase iOS app configuration."
            case .missingAppToken, .invalidAppCredential:
                return "APNs app verification is not configured correctly. Enable Push Notifications, Background Modes, and upload an APNs key in Firebase Console."
            case .sessionExpired:
                return "The verification code expired. Request a new code and try again."
            case .invalidVerificationCode:
                return "The verification code is incorrect. Enter the latest 6-digit code from Firebase."
            case .invalidVerificationID:
                return "The verification session is no longer valid. Request a new OTP and try again."
            default:
                break
            }
        }

#if canImport(UIKit)
        if UIDevice.current.userInterfaceIdiom != .unspecified,
           ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil {
            return "Simulator phone auth uses reCAPTCHA. For real SMS on a device, finish APNs setup in Apple Developer and Firebase Console. Original error: \(nsError.localizedDescription)"
        }
#endif

        return nsError.localizedDescription
    }
}

private enum PhoneAuthError: LocalizedError {
    case invalidPhoneNumber
    case missingVerificationID
    case invalidOTP
    case authenticationFailed

    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Enter a valid phone number in international format, for example +94771234567."
        case .missingVerificationID:
            return "We could not start phone verification. Please request a new code."
        case .invalidOTP:
            return "Enter the 6-digit code from the SMS."
        case .authenticationFailed:
            return "Phone verification failed. Please try again."
        }
    }
}