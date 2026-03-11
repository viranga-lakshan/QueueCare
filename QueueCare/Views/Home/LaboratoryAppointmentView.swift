import SwiftUI

struct LaboratoryAppointmentView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController
    
    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let cardBackgroundBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let cardBackgroundBeige = Color(red: 242 / 255, green: 235 / 255, blue: 227 / 255)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    private let warningRed = Color(red: 190 / 255, green: 68 / 255, blue: 68 / 255)
    
    private var appointment: LaboratoryAppointment {
        laboratoryController.appointment
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
                        Text(appointment.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(textColor)
                        
                        Text("Step \(appointment.currentStep) / \(appointment.totalSteps)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(mutedTextColor)
                    }
                    .padding(.top, 24)
                    
                    dateTimeCard
                        .padding(.horizontal, 22)
                        .padding(.top, 36)
                    
                    preparationCard
                        .padding(.horizontal, 22)
                        .padding(.top, 20)
                    
                    estimatedDurationInfo
                        .padding(.top, 32)
                    
                    Button(action: controller.showLaboratoryPayment) {
                        Text(appointment.buttonTitle)
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
            .padding(.top, 8)
            .background(backgroundColor.opacity(0.97))
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: controller.showLaboratoryRequest) {
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
    
    private var dateTimeCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "calendar")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(iconBlue)
                    .frame(width: 42, height: 42)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Date and Time")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    VStack(spacing: 10) {
                        dateSelector
                        timeSlotSelector
                    }
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(cardBackgroundBlue)
        )
    }
    
    private var dateSelector: some View {
        DatePicker(
            "",
            selection: $laboratoryController.selectedDate,
            in: Date()...,
            displayedComponents: .date
        )
        .datePickerStyle(.compact)
        .labelsHidden()
        .tint(iconBlue)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white)
        )
    }
    
    private var timeSlotSelector: some View {
        HStack(spacing: 10) {
            ForEach(appointment.availableTimeSlots) { slot in
                timeSlotButton(slot)
            }
        }
    }
    
    private func timeSlotButton(_ slot: TimeSlot) -> some View {
        let isSelected = laboratoryController.selectedTimeSlotID == slot.id
        
        return Button {
            laboratoryController.selectTimeSlot(slot.id)
        } label: {
            Text(slot.time)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? .white : textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isSelected ? iconBlue : .white)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var preparationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(appointment.preparation.title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(warningRed)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(appointment.preparation.items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(warningRed)
                        
                        Text(item)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(warningRed)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(cardBackgroundBeige)
        )
    }
    
    private var estimatedDurationInfo: some View {
        HStack(spacing: 10) {
            Image(systemName: "clock")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(mutedTextColor)
            
            Text("Estimated duration: \(appointment.estimatedDuration)")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(mutedTextColor)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: laboratoryController.selectedDate)
    }
}

#Preview {
    LaboratoryAppointmentView(controller: QueueController(), laboratoryController: LaboratoryController())
}
