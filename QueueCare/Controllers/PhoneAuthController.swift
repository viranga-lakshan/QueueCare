import Foundation
import Combine

@MainActor
final class PhoneAuthController: ObservableObject {
    static let defaultCountryCode = "+94"
    private static let hardcodedOTP = "123456" // Hardcoded OTP for testing

    let otpDigits = 6

    @Published private(set) var isSendingCode = false
    @Published private(set) var isVerifyingCode = false
    @Published private(set) var currentPhoneNumber = ""
    @Published private(set) var lastVerifiedCode = ""
    @Published var errorMessage: String?

    var countryCode: String {
        Self.defaultCountryCode
    }

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
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        isSendingCode = false
        currentPhoneNumber = normalizedPhoneNumber
        lastVerifiedCode = ""
        
        print("Hardcoded OTP sent: \(Self.hardcodedOTP)")
        return true
    }

    func verifyOTP(_ rawCode: String) async -> Bool {
        clearError()

        let verificationCode = rawCode.filter(\.isNumber)
        guard verificationCode.count == otpDigits else {
            errorMessage = PhoneAuthError.invalidOTP.errorDescription
            return false
        }

        isVerifyingCode = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        isVerifyingCode = false
        
        // Accept hardcoded OTP or any 6-digit code for UI testing
        if verificationCode == Self.hardcodedOTP || verificationCode.count == otpDigits {
            lastVerifiedCode = verificationCode
            return true
        } else {
            errorMessage = "Invalid verification code. Use \(Self.hardcodedOTP) for testing."
            return false
        }
    }

    var maskedPhoneNumber: String {
        guard currentPhoneNumber.count > 6 else { return currentPhoneNumber }

        let prefix = currentPhoneNumber.prefix(4)
        let suffix = currentPhoneNumber.suffix(3)
        return "\(prefix)••••\(suffix)"
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
        let pattern = "^\\+94[0-9]{9}$"
        return phoneNumber.range(of: pattern, options: .regularExpression) != nil
    }
}

private enum PhoneAuthError: LocalizedError {
    case invalidPhoneNumber
    case invalidOTP

    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Enter a valid Sri Lankan mobile number, for example +94771234567."
        case .invalidOTP:
            return "Enter the 6-digit code from the SMS."
        }
    }
}
