import SwiftUI

struct LaboratoryDoctorReviewView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController
    
    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let doctorCardBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconBlue = Color(red: 93 / 255, green: 135 / 255, blue: 185 / 255)
    private let darkBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    private let successGreen = Color(red: 76 / 255, green: 175 / 255, blue: 80 / 255)
    private let dischargeGreen = Color(red: 210 / 255, green: 234 / 255, blue: 210 / 255)
    
    private var review: LaboratoryDoctorReview {
        laboratoryController.doctorReview
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                    .padding(.top, 12)
                    .padding(.horizontal, 22)
                
                VStack(spacing: 5) {
                    Text(review.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    Text("Step \(review.currentStep) / \(review.totalSteps)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.top, 14)
                
                // Review Icon
                ZStack {
                    Circle()
                        .fill(iconBlue)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 18)
                
                Text(review.heading)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
                    .padding(.top, 14)
                    .multilineTextAlignment(.center)
                
                // Doctor Info Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 14) {
                        // Doctor Avatar
                        ZStack {
                            Circle()
                                .fill(darkBlue)
                                .frame(width: 54, height: 54)
                            
                            Text(review.doctor.initials)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(review.doctor.name)
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundStyle(textColor)
                            
                            Text(review.doctor.specialty)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(mutedTextColor)
                        }
                        
                        Spacer()
                    }
                    
                    // Review Status
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(successGreen)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(review.reviewStatus.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(mutedTextColor)
                            
                            Text(review.reviewStatus.statusText)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(successGreen)
                        }
                        
                        Spacer()
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    )
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(doctorCardBlue)
                )
                .padding(.horizontal, 22)
                .padding(.top, 18)
                
                // Next Steps Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Next Steps")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    ForEach(review.nextSteps) { step in
                        HStack(alignment: .top, spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(iconBlue)
                                    .frame(width: 24, height: 24)
                                
                                Text("\(step.stepNumber)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            
                            Text(step.description)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(mutedTextColor)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                            
                            Spacer(minLength: 0)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                )
                .padding(.horizontal, 22)
                .padding(.top, 14)
                
                Spacer(minLength: 10)
                
                // Expected Discharge Card
                VStack(spacing: 8) {
                    Text(review.expectedDischarge.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(successGreen)
                    
                    Text(review.expectedDischarge.date)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(successGreen)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(dischargeGreen)
                )
                .padding(.horizontal, 22)
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
            Button(action: controller.showLaboratoryTestCompletion) {
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
}

#Preview {
    LaboratoryDoctorReviewView(controller: QueueController(), laboratoryController: LaboratoryController())
}
