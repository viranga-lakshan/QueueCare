import SwiftUI

struct LaboratoryPaymentView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController
    
    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let lightMutedTextColor = Color(red: 0.73, green: 0.76, blue: 0.78)
    private let cardBackgroundBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    private let priceBlue = Color(red: 63 / 255, green: 106 / 255, blue: 180 / 255)
    
    private var payment: LaboratoryPayment {
        laboratoryController.payment
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)
                        .padding(.horizontal, 22)
                    
                    VStack(spacing: 6) {
                        Text(payment.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                        
                        Text("Step \(payment.currentStep) / \(payment.totalSteps)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 24)
                    
                    testSummaryCard
                        .padding(.horizontal, 22)
                        .padding(.top, 36)
                    
                    paymentMethodCard
                        .padding(.horizontal, 22)
                        .padding(.top, 20)
                    
                    Button(action: controller.showLaboratoryConfirmation) {
                        Text(payment.buttonTitle)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(brandColor)
                                    .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 22)
                    .padding(.top, 48)
                    .padding(.bottom, 36)
                }
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
            Button(action: controller.showLaboratoryAppointment) {
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
    
    private var testSummaryCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(payment.testSummary.title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.bottom, 18)
            
            VStack(spacing: 12) {
                ForEach(payment.testSummary.items) { item in
                    HStack {
                        Text(item.name)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(textColor)
                        
                        Spacer()
                        
                        Text(item.formattedPrice)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)
                    }
                }
                
                Divider()
                    .background(mutedTextColor.opacity(0.3))
                    .padding(.vertical, 6)
                
                HStack {
                    Text("Total")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    Spacer()
                    
                    Text(String(format: "Rs. %.2f", payment.testSummary.total))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(priceBlue)
                }
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(cardBackgroundBlue)
        )
    }
    
    private var paymentMethodCard: some View {
        VStack(spacing: 0) {
            ForEach(payment.paymentMethods) { method in
                paymentMethodRow(method)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }
    
    private func paymentMethodRow(_ method: PaymentMethod) -> some View {
        let isSelected = laboratoryController.selectedPaymentMethodID == method.id
        
        return Button {
            laboratoryController.selectPaymentMethod(method.id)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: method.type.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(iconBlue)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(method.displayName)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    if let cardDisplay = method.cardDisplay {
                        Text(cardDisplay)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(lightMutedTextColor)
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(iconBlue.opacity(0.6), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(iconBlue)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LaboratoryPaymentView(controller: QueueController(), laboratoryController: LaboratoryController())
}
