import SwiftUI

struct BookAppointmentView: View {
    @ObservedObject var controller: QueueController

    @State private var showDatePicker = false

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)

    private var appointment: BookAppointment {
        controller.bookAppointment
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d, yyyy"
        return f.string(from: controller.selectedBookingDate)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 18)
                        .padding(.horizontal, 22)

                    Text("Book Appointment")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                        .padding(.top, 28)

                    // MARK: Select Date
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Date")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)

                        Button {
                            showDatePicker = true
                        } label: {
                            HStack {
                                Text(formattedDate)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(textColor)

                                Spacer(minLength: 0)

                                Image(systemName: "calendar")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(mutedTextColor)
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 22)
                    .padding(.top, 32)

                    // MARK: Select Time Slot
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Select Time Slot")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(appointment.timeSlots) { slot in
                                timeSlotButton(slot)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 22)
                    .padding(.top, 28)

                    // MARK: Confirm Button
                    Button(action: controller.showAppointmentPayment) {
                        Text("Confirm Appointment")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(brandColor)
                                    .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 22)
                    .padding(.top, 36)

                    // MARK: OR Divider
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(mutedTextColor.opacity(0.35))
                            .frame(height: 1)

                        Text("OR")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(mutedTextColor)

                        Rectangle()
                            .fill(mutedTextColor.opacity(0.35))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 22)

                    // MARK: Join Live Queue
                    Button(action: controller.showLiveQueue) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(.white.opacity(0.9))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Join Live Queue")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)

                                Text(appointment.estimatedWaitLabel)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.85))
                            }

                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(brandColor)
                                .shadow(color: brandColor.opacity(0.22), radius: 10, x: 0, y: 5)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 22)
                    .padding(.top, 16)
                    .padding(.bottom, 36)
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            datePicker
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
            Button(action: controller.showDepartmentSelection) {
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
                .overlay(Circle().stroke(.white, lineWidth: 2))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }

    private func timeSlotButton(_ slot: BookingTimeSlot) -> some View {
        let isSelected = controller.selectedBookingSlotID == slot.id

        return Button {
            controller.selectBookingSlot(slot.id)
        } label: {
            Text(slot.time)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    !slot.isAvailable ? mutedTextColor.opacity(0.5) :
                    isSelected ? .white : textColor
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            !slot.isAvailable ? Color.white.opacity(0.5) :
                            isSelected ? brandColor : Color.white
                        )
                        .shadow(color: .black.opacity(slot.isAvailable ? 0.06 : 0.02), radius: 6, x: 0, y: 2)
                )
        }
        .buttonStyle(.plain)
        .disabled(!slot.isAvailable)
    }

    private var datePicker: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Done") { showDatePicker = false }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(brandColor)
                    .padding(.trailing, 20)
                    .padding(.top, 16)
            }

            DatePicker(
                "",
                selection: $controller.selectedBookingDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(brandColor)
            .padding(.horizontal, 16)

            Spacer()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    BookAppointmentView(controller: QueueController())
}
