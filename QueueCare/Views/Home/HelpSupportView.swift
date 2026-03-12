import SwiftUI

struct HelpSupportView: View {
    
    @ObservedObject var controller: QueueController
    @State private var selectedSection: HelpSection?
    @State private var expandedQuestions: Set<UUID> = []
    @State private var showContactSheet = false
    
    private let helpModel = HelpSupportModel.sample
    private let brandColor = Color(red: 54/255, green: 180/255, blue: 165/255)
    private let backgroundColor = Color(red: 248/255, green: 250/255, blue: 252/255)
    private let textColor = Color(red: 30/255, green: 41/255, blue: 59/255)
    private let mutedTextColor = Color(red: 100/255, green: 116/255, blue: 139/255)
    private let secondaryText = Color(red: 71/255, green: 85/255, blue: 105/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerCard
                        
                        emergencyCard
                        
                        helpTopicsSection
                        
                        contactSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showContactSheet) {
            ContactSupportSheet(contactInfo: helpModel.contactInfo, brandColor: brandColor)
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(
                selectedTab: controller.selectedDashboardTab,
                accentColor: brandColor
            ) { tab in
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
    
    // MARK: - TOP BAR
    
    private var topBar: some View {
        HStack {
            Button(action: controller.showDashboard) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
            }
            
            VStack(spacing: 2) {
                Text("Help & Support")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(textColor)
                
                Text("We're here to help")
                    .font(.system(size: 13))
                    .foregroundStyle(mutedTextColor)
            }
            
            Spacer()
            
            Button(action: { showContactSheet = true }) {
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(brandColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - HEADER CARD
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(brandColor)
            
            Text("How can we help you?")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
            
            Text("Browse topics below or contact our support team")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(mutedTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }
    
    // MARK: - EMERGENCY CARD
    
    private var emergencyCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Emergency?")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Call \(helpModel.emergencyNumber) immediately")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
                
                Button(action: callEmergency) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.red)
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.red)
                .shadow(color: Color.red.opacity(0.3), radius: 10, x: 0, y: 4)
        )
    }
    
    // MARK: - HELP TOPICS
    
    private var helpTopicsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Help Topics")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                ForEach(helpModel.sections) { section in
                    helpTopicCard(section: section)
                }
            }
        }
    }
    
    private func helpTopicCard(section: HelpSection) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    if selectedSection?.id == section.id {
                        selectedSection = nil
                    } else {
                        selectedSection = section
                    }
                }
            }) {
                HStack(spacing: 14) {
                    Image(systemName: section.icon)
                        .font(.system(size: 22))
                        .foregroundStyle(brandColor)
                        .frame(width: 44, height: 44)
                        .background(brandColor.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(section.title)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(textColor)
                        
                        Text(section.description)
                            .font(.system(size: 13))
                            .foregroundStyle(mutedTextColor)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(mutedTextColor)
                        .rotationEffect(.degrees(selectedSection?.id == section.id ? 90 : 0))
                }
                .padding(14)
            }
            .buttonStyle(.plain)
            
            if selectedSection?.id == section.id {
                VStack(spacing: 8) {
                    ForEach(section.items) { item in
                        faqItem(item: item)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private func faqItem(item: HelpItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    if expandedQuestions.contains(item.id) {
                        expandedQuestions.remove(item.id)
                    } else {
                        expandedQuestions.insert(item.id)
                    }
                }
            }) {
                HStack {
                    Text(item.question)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(textColor)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: expandedQuestions.contains(item.id) ? "minus.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(brandColor)
                }
            }
            .buttonStyle(.plain)
            
            if expandedQuestions.contains(item.id) {
                Text(item.answer)
                    .font(.system(size: 13))
                    .foregroundStyle(secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backgroundColor)
        )
    }
    
    // MARK: - CONTACT SECTION
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Contact Us")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                contactButton(
                    icon: "phone.fill",
                    title: "Call Support",
                    subtitle: helpModel.contactInfo.phoneNumber,
                    color: Color.blue,
                    action: callSupport
                )
                
                contactButton(
                    icon: "envelope.fill",
                    title: "Email Us",
                    subtitle: helpModel.contactInfo.email,
                    color: Color.orange,
                    action: emailSupport
                )
                
                contactButton(
                    icon: "message.fill",
                    title: "WhatsApp",
                    subtitle: helpModel.contactInfo.whatsapp,
                    color: Color.green,
                    action: whatsappSupport
                )
            }
            
            Text("Available \(helpModel.contactInfo.hours)")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(mutedTextColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
        }
    }
    
    private func contactButton(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(textColor)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(mutedTextColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(mutedTextColor)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - ACTIONS
    
    private func callEmergency() {
        if let url = URL(string: "tel://\(helpModel.emergencyNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func callSupport() {
        let phone = helpModel.contactInfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func emailSupport() {
        if let url = URL(string: "mailto:\(helpModel.contactInfo.email)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func whatsappSupport() {
        let phone = helpModel.contactInfo.whatsapp.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "https://wa.me/\(phone)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - CONTACT SHEET

struct ContactSupportSheet: View {
    let contactInfo: ContactInfo
    let brandColor: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(brandColor)
                    .padding(.top, 40)
                
                VStack(spacing: 12) {
                    Text("Contact Support")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Text("Choose how you'd like to reach us")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    contactRow(icon: "phone.fill", title: "Phone", value: contactInfo.phoneNumber, color: .blue)
                    contactRow(icon: "envelope.fill", title: "Email", value: contactInfo.email, color: .orange)
                    contactRow(icon: "message.fill", title: "WhatsApp", value: contactInfo.whatsapp, color: .green)
                }
                .padding(.horizontal, 20)
                
                Text("Available \(contactInfo.hours)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func contactRow(icon: String, title: String, value: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(value)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    HelpSupportView(controller: QueueController())
}
