import Foundation

struct LaboratoryPayment {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let testSummary: TestSummary
    let paymentMethods: [PaymentMethod]
    let selectedPaymentMethodID: String?
    let buttonTitle: String
    
    static let mock = LaboratoryPayment(
        title: "Laboratory",
        currentStep: 4,
        totalSteps: 7,
        testSummary: TestSummary(
            title: "Test Summary",
            items: [
                TestItem(name: "Blood Test", price: 450.00),
                TestItem(name: "X - Ray", price: 1250.00),
                TestItem(name: "Blood Test", price: 800.00)
            ],
            total: 2500.00
        ),
        paymentMethods: [
            PaymentMethod(
                id: "card1",
                type: .creditDebitCard,
                displayName: "Credit/Debit Card",
                cardLastFour: "4532"
            )
        ],
        selectedPaymentMethodID: "card1",
        buttonTitle: "Confirm Payment"
    )
}

struct TestSummary {
    let title: String
    let items: [TestItem]
    let total: Double
}

struct TestItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    
    var formattedPrice: String {
        String(format: "Rs. %.2f", price)
    }
}

struct PaymentMethod: Identifiable {
    let id: String
    let type: PaymentMethodType
    let displayName: String
    let cardLastFour: String?
    
    var cardDisplay: String? {
        guard let lastFour = cardLastFour else { return nil }
        return "•••• •••• •••• \(lastFour)"
    }
}

enum PaymentMethodType {
    case creditDebitCard
    case insurance
    case cash
    
    var iconName: String {
        switch self {
        case .creditDebitCard:
            return "creditcard.fill"
        case .insurance:
            return "cross.case.fill"
        case .cash:
            return "banknote.fill"
        }
    }
}
