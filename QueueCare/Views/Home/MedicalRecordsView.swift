import SwiftUI

struct MedicalRecordsView: View {

    @ObservedObject var controller: QueueController

    // MARK: - Design Tokens (aligned with other Home screens)
    private let brandColor = Color(red: 54 / 255, green: 180 / 255, blue: 165 / 255)
    private let backgroundColor = Color(red: 248 / 255, green: 250 / 255, blue: 252 / 255)
    private let textColor = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)
    private let mutedTextColor = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)

    // Accent colors reused from the dashboard quick-action palette
    private let actionBlue = Color(red: 91 / 255, green: 150 / 255, blue: 225 / 255)
    private let actionOrange = Color(red: 240 / 255, green: 149 / 255, blue: 107 / 255)
    private let actionPurple = Color(red: 147 / 255, green: 112 / 255, blue: 219 / 255)
    private let actionGreen = Color(red: 121 / 255, green: 195 / 255, blue: 160 / 255)

    private var patientName: String { controller.selectedChildName.isEmpty ? controller.dashboard.patientName : controller.selectedChildName }

    private var documents: [MedicalRecordDocument] {
        [
            MedicalRecordDocument(
                title: "OPD Visit Summary",
                subtitle: "General OPD • Consultation Notes",
                dateLabel: "Mar 10, 2026",
                icon: "doc.text.fill",
                tint: actionBlue,
                tag: "PDF"
            ),
            MedicalRecordDocument(
                title: "Lab Report",
                subtitle: "Full Blood Count (FBC)",
                dateLabel: "Mar 08, 2026",
                icon: "cross.vial.fill",
                tint: actionOrange,
                tag: "Result"
            ),
            MedicalRecordDocument(
                title: "Prescription",
                subtitle: "Pharmacy • 2 items",
                dateLabel: "Mar 08, 2026",
                icon: "pills.fill",
                tint: actionGreen,
                tag: "Active"
            ),
            MedicalRecordDocument(
                title: "Radiology Note",
                subtitle: "X‑Ray • Chest",
                dateLabel: "Feb 26, 2026",
                icon: "waveform.path.ecg",
                tint: actionPurple,
                tag: "Report"
            )
        ]
    }

    private var meds: [MedicationEntry] {
        [
            MedicationEntry(name: "Amoxicillin 500mg", instructions: "1 capsule • 3× daily", duration: "5 days", status: .active),
            MedicationEntry(name: "Paracetamol 500mg", instructions: "1 tablet • as needed", duration: "—", status: .asNeeded)
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 18) {
                            headerCard
                            summaryGrid
                            documentsSection
                            medicationsSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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

    // MARK: - Top Bar

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
                Text("Medical Records")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(textColor)

                Text(patientName)
                    .font(.system(size: 13))
                    .foregroundStyle(mutedTextColor)
            }

            Spacer()

            Image(systemName: "lock.shield.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(brandColor)
                .frame(width: 40, height: 40)
                .background(.white)
                .clipShape(Circle())
                .accessibilityLabel("Protected")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: - Header Card

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(actionOrange.opacity(0.14))
                        .frame(width: 56, height: 56)

                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(actionOrange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Your health info, in one place")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("Summaries, lab results, and prescriptions")
                        .font(.system(size: 13))
                        .foregroundStyle(mutedTextColor)
                }

                Spacer()
            }

            HStack(spacing: 10) {
                infoPill(icon: "clock.fill", text: "Last updated: Mar 10")
                infoPill(icon: "person.fill", text: "Profile: \(patientName)")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func infoPill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(brandColor)

            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(brandColor.opacity(0.10))
        )
    }

    // MARK: - Summary

    private var summaryGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Summary")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)

            HStack(spacing: 10) {
                summaryCard(title: "Blood Type", value: "O+", icon: "drop.fill", tint: actionBlue)
                summaryCard(title: "Allergies", value: "None", icon: "allergens", tint: actionGreen)
            }

            HStack(spacing: 10) {
                summaryCard(title: "Conditions", value: "—", icon: "heart.text.square.fill", tint: actionPurple)
                summaryCard(title: "Last Visit", value: "Mar 10", icon: "calendar", tint: actionOrange)
            }
        }
    }

    private func summaryCard(title: String, value: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 34, height: 34)
                    .background(tint.opacity(0.12))
                    .clipShape(Circle())

                Spacer()
            }

            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(mutedTextColor)

            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    // MARK: - Documents

    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent Documents")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                ForEach(documents) { doc in
                    NavigationLink {
                        MedicalRecordDetailView(
                            patientName: patientName,
                            document: doc,
                            brandColor: brandColor,
                            backgroundColor: backgroundColor,
                            textColor: textColor,
                            mutedTextColor: mutedTextColor
                        )
                    } label: {
                        documentRow(doc)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func documentRow(_ doc: MedicalRecordDocument) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(doc.tint.opacity(0.14))
                    .frame(width: 44, height: 44)

                Image(systemName: doc.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(doc.tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(doc.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Spacer(minLength: 10)

                    Text(doc.tag)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(doc.tint)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule(style: .continuous)
                                .fill(doc.tint.opacity(0.12))
                        )
                }

                Text(doc.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(mutedTextColor)
                    .lineLimit(1)

                Text(doc.dateLabel)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(mutedTextColor)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(mutedTextColor.opacity(0.8))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    // MARK: - Medications

    private var medicationsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Medications")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                ForEach(meds) { med in
                    medicationRow(med)
                }
            }
        }
    }

    private func medicationRow(_ med: MedicationEntry) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(med.status.tint.opacity(0.14))
                    .frame(width: 44, height: 44)

                Image(systemName: "pills.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(med.status.tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(med.name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)

                    Spacer()

                    Text(med.status.label)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(med.status.tint)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule(style: .continuous)
                                .fill(med.status.tint.opacity(0.12))
                        )
                }

                Text(med.instructions)
                    .font(.system(size: 13))
                    .foregroundStyle(mutedTextColor)
                    .lineLimit(1)

                Text("Duration: \(med.duration)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(mutedTextColor)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

private struct MedicalRecordDetailView: View {

    @Environment(\.dismiss) private var dismiss

    let patientName: String
    let document: MedicalRecordDocument
    let brandColor: Color
    let backgroundColor: Color
    let textColor: Color
    let mutedTextColor: Color

    private var recordID: String {
        switch document.title {
        case "OPD Visit Summary":
            return "MR-OPD-20260310-01"
        case "Lab Report":
            return "MR-LAB-20260308-12"
        case "Prescription":
            return "MR-RX-20260308-02"
        default:
            return "MR-IMG-20260226-07"
        }
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        headerCard
                        overviewCard
                        contentCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 100)
                }
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
            }

            VStack(spacing: 2) {
                Text(document.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(textColor)
                    .lineLimit(1)

                Text(document.dateLabel)
                    .font(.system(size: 13))
                    .foregroundStyle(mutedTextColor)
            }

            Spacer()

            Text(document.tag)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(document.tint)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(
                    Capsule(style: .continuous)
                        .fill(document.tint.opacity(0.12))
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: - Header

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(document.tint.opacity(0.14))
                        .frame(width: 56, height: 56)

                    Image(systemName: document.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(document.tint)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(document.subtitle)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(textColor)
                        .lineLimit(2)

                    Text("Record ID: \(recordID)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(mutedTextColor)
                }

                Spacer()
            }

            HStack(spacing: 10) {
                infoPill(icon: "person.fill", text: "Profile: \(patientName)")
                infoPill(icon: "lock.fill", text: "Private")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func infoPill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(brandColor)

            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(brandColor.opacity(0.10))
        )
    }

    // MARK: - Overview

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            VStack(spacing: 10) {
                keyValueRow(label: "Facility", value: "QueueCare General Hospital")
                keyValueRow(label: "Department", value: departmentLabel)
                keyValueRow(label: "Provider", value: providerLabel)
                keyValueRow(label: "Status", value: statusLabel)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private func keyValueRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(mutedTextColor)

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(textColor)
                .multilineTextAlignment(.trailing)
        }
    }

    private var departmentLabel: String {
        switch document.title {
        case "OPD Visit Summary":
            return "General OPD"
        case "Lab Report":
            return "Laboratory"
        case "Prescription":
            return "Pharmacy"
        default:
            return "Radiology"
        }
    }

    private var providerLabel: String {
        switch document.title {
        case "OPD Visit Summary":
            return "Dr. A. Mensah"
        case "Lab Report":
            return "Lab Technician"
        case "Prescription":
            return "Pharmacist"
        default:
            return "Radiographer"
        }
    }

    private var statusLabel: String {
        switch document.title {
        case "Prescription":
            return "Active"
        default:
            return "Available"
        }
    }

    // MARK: - Content

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(contentTitle)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            contentBody
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
        )
    }

    private var contentTitle: String {
        switch document.title {
        case "Lab Report":
            return "Results"
        case "Prescription":
            return "Prescription Items"
        case "Radiology Note":
            return "Impression"
        default:
            return "Clinical Notes"
        }
    }

    @ViewBuilder
    private var contentBody: some View {
        switch document.title {
        case "OPD Visit Summary":
            VStack(alignment: .leading, spacing: 10) {
                bulletLine("Chief complaint: Headache")
                bulletLine("Assessment: Mild dehydration")
                bulletLine("Plan: Increase fluids, rest, follow-up in 1 week")

                Divider().padding(.vertical, 4)

                HStack(spacing: 10) {
                    metricPill(label: "BP", value: "118/76")
                    metricPill(label: "Temp", value: "36.8°C")
                    metricPill(label: "HR", value: "82")
                }
            }

        case "Lab Report":
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    resultTile(name: "WBC", value: "6.2", unit: "×10⁹/L", tint: document.tint)
                    resultTile(name: "HGB", value: "13.8", unit: "g/dL", tint: document.tint)
                }

                HStack(spacing: 10) {
                    resultTile(name: "PLT", value: "245", unit: "×10⁹/L", tint: document.tint)
                    resultTile(name: "RBC", value: "4.7", unit: "×10¹²/L", tint: document.tint)
                }

                Text("Reference ranges may vary by lab.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(mutedTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 2)
            }

        case "Prescription":
            VStack(alignment: .leading, spacing: 10) {
                prescriptionRow(name: "Amoxicillin 500mg", instruction: "1 capsule • 3× daily", duration: "5 days")
                Divider()
                prescriptionRow(name: "Paracetamol 500mg", instruction: "1 tablet • as needed", duration: "—")
            }

        default:
            VStack(alignment: .leading, spacing: 10) {
                bulletLine("Findings: No acute cardiopulmonary abnormality.")
                bulletLine("Heart size within normal limits.")
                bulletLine("Recommendation: Clinical correlation advised.")
            }
        }
    }

    private func bulletLine(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(document.tint)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(textColor)

            Spacer(minLength: 0)
        }
    }

    private func metricPill(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(mutedTextColor)

            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(backgroundColor)
        )
    }

    private func resultTile(name: String, value: String, unit: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(mutedTextColor)

            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            Text(unit)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(mutedTextColor)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(tint.opacity(0.10))
        )
    }

    private func prescriptionRow(name: String, instruction: String, duration: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            Text(instruction)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(mutedTextColor)

            Text("Duration: \(duration)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(mutedTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MedicalRecordDocument: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let dateLabel: String
    let icon: String
    let tint: Color
    let tag: String
}

private struct MedicationEntry: Identifiable {
    enum Status {
        case active
        case asNeeded

        var label: String {
            switch self {
            case .active: return "ACTIVE"
            case .asNeeded: return "PRN"
            }
        }

        var tint: Color {
            switch self {
            case .active:
                return Color(red: 121 / 255, green: 195 / 255, blue: 160 / 255)
            case .asNeeded:
                return Color(red: 91 / 255, green: 150 / 255, blue: 225 / 255)
            }
        }
    }

    let id = UUID()
    let name: String
    let instructions: String
    let duration: String
    let status: Status
}

#Preview {
    MedicalRecordsView(controller: QueueController())
}
