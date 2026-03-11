import SwiftUI
import PhotosUI

struct SelectPatientView: View {
    @ObservedObject var controller: QueueController
    @State private var showAddPatientSheet = false

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let cardBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 18)
                    .padding(.horizontal, 22)

                Text("Select Patient")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
                    .padding(.top, 24)

                if controller.selectablePatients.isEmpty {
                    Spacer()
                    Text("No patients added yet.\nTap \"Add Patient\" to get started.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(controller.selectablePatients) { patient in
                                patientCard(patient)
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.top, 28)
                        .padding(.bottom, 20)
                    }
                }

                Button {
                    showAddPatientSheet = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20, weight: .semibold))
                        Text("Add Patient")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(brandColor)
                            .shadow(color: brandColor.opacity(0.24), radius: 10, x: 0, y: 6)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.bottom, 28)
            }
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(selectedTab: controller.selectedDashboardTab, accentColor: brandColor) { tab in
                controller.selectDashboardTab(tab)
            }
            .padding(.top, 8)
            .background(backgroundColor.opacity(0.97))
        }
        .sheet(isPresented: $showAddPatientSheet) {
            AddPatientSheet(controller: controller, isPresented: $showAddPatientSheet)
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: controller.showDashboard) {
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

    private func patientCard(_ patient: SelectablePatient) -> some View {
        HStack(spacing: 14) {
            Group {
                if let photo = patient.photo {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        Circle().fill(cardBlue)
                        Image(systemName: "person.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(iconBlue)
                    }
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(patient.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
                Text("\(patient.age) years • \(patient.relation)")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(mutedTextColor)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(mutedTextColor.opacity(0.5))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Add Patient Sheet

private struct AddPatientSheet: View {
    @ObservedObject var controller: QueueController
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var ageText = ""
    @State private var relation = ""
    @State private var contactNumber = ""
    @State private var email = ""
    @State private var gender = "Male"
    @State private var selectedPhoto: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?

    private let genders = ["Male", "Female", "Other"]

    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    private let cardBlue = Color(red: 204 / 255, green: 230 / 255, blue: 240 / 255)

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // Photo picker
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        ZStack(alignment: .bottomTrailing) {
                            Group {
                                if let photo = selectedPhoto {
                                    Image(uiImage: photo)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    ZStack {
                                        Circle().fill(cardBlue)
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundStyle(iconBlue)
                                    }
                                }
                            }
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())

                            ZStack {
                                Circle()
                                    .fill(brandColor)
                                    .frame(width: 28, height: 28)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .offset(x: 2, y: 2)
                        }
                    }
                    .onChange(of: photoPickerItem) { _, item in
                        Task {
                            if let data = try? await item?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedPhoto = image
                            }
                        }
                    }
                    .padding(.top, 8)

                    // Form fields
                    VStack(spacing: 16) {
                        formField(label: "Patient Name", placeholder: "Enter full name", text: $name, keyboard: .default)
                        formField(label: "Age", placeholder: "Enter age", text: $ageText, keyboard: .numberPad)
                        formField(label: "Relationship", placeholder: "e.g. Mother, Brother, Friend", text: $relation, keyboard: .default)
                        formField(label: "Contact Number", placeholder: "Enter phone number", text: $contactNumber, keyboard: .phonePad)
                        formField(label: "Email", placeholder: "Enter email address", text: $email, keyboard: .emailAddress)

                        // Gender picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(mutedTextColor)

                            HStack(spacing: 10) {
                                ForEach(genders, id: \.self) { option in
                                    Button {
                                        gender = option
                                    } label: {
                                        Text(option)
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundStyle(gender == option ? .white : textColor)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(gender == option ? brandColor : backgroundColor)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 22)

                    // Add button
                    Button {
                        let trimmedName = name.trimmingCharacters(in: .whitespaces)
                        guard !trimmedName.isEmpty else { return }
                        controller.addSelectablePatient(
                            name: trimmedName,
                            age: Int(ageText) ?? 0,
                            relation: relation.trimmingCharacters(in: .whitespaces).isEmpty ? "Self" : relation.trimmingCharacters(in: .whitespaces),
                            contactNumber: contactNumber.trimmingCharacters(in: .whitespaces),
                            gender: gender,
                            email: email.trimmingCharacters(in: .whitespaces),
                            photo: selectedPhoto
                        )
                        isPresented = false
                    } label: {
                        Text("Add")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(brandColor)
                                    .shadow(color: brandColor.opacity(0.22), radius: 8, x: 0, y: 4)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 36)
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationTitle("Add Patient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                        .foregroundStyle(brandColor)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func formField(label: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(mutedTextColor)

            TextField(placeholder, text: text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .keyboardType(keyboard)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(backgroundColor)
                )
        }
    }
}

#Preview {
    SelectPatientView(controller: QueueController())
}
