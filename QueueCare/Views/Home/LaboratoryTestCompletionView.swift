import SwiftUI

struct LaboratoryTestCompletionView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController
    
    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let cardBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let cardGreen = Color(red: 210 / 255, green: 234 / 255, blue: 210 / 255)
    private let successGreen = Color(red: 76 / 255, green: 175 / 255, blue: 80 / 255)
    private let referenceBlue = Color(red: 33 / 255, green: 150 / 255, blue: 243 / 255)
    
    private var completion: LaboratoryTestCompletion {
        laboratoryController.testCompletion
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                    .padding(.top, 12)
                    .padding(.horizontal, 22)
                
                VStack(spacing: 5) {
                    Text(completion.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    Text("Step \(completion.currentStep) / \(completion.totalSteps)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.top, 16)
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(successGreen.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .fill(successGreen)
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 24)
                
                Text(completion.heading)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
                    .padding(.top, 14)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(completion.subheading)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(mutedTextColor)
                    .padding(.top, 5)
                    
                // Completion Details Card
                VStack(alignment: .leading, spacing: 14) {
                    detailRow(
                        label: "Completion Date",
                        value: "\(completion.completionDate) at\n\(completion.completionTime)"
                    )
                    
                    Divider()
                    
                    detailRow(
                        label: "Tests Completed",
                        value: completion.testsCompleted,
                        valueColor: textColor
                    )
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Reference Number")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(mutedTextColor)
                        
                        Text(completion.referenceNumber)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(referenceBlue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(cardBlue)
                )
                .padding(.horizontal, 22)
                .padding(.top, 18)
                
                // Notification Card
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(successGreen)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(completion.notificationTitle)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                        
                        Text(completion.notificationMessage)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(mutedTextColor)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(cardGreen)
                )
                .padding(.horizontal, 22)
                .padding(.top, 12)
                
                // View Report Button
                Button(action: controller.showLaboratoryDoctorReview) {
                    Text(completion.buttonTitle)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 20)
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
            Button(action: controller.showLaboratoryTestProgress) {
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
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
    
    private func detailRow(label: String, value: String, valueColor: Color? = nil) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(mutedTextColor)
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(valueColor ?? textColor)
        }
    }
}

#Preview {
    LaboratoryTestCompletionView(controller: QueueController(), laboratoryController: LaboratoryController())
}
