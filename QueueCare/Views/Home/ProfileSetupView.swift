import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    @ObservedObject var controller: QueueController

    @State private var name = ""
    @State private var contactNumber = ""
    @State private var email = ""
    @State private var gender = "Male"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var nameError = false
    @State private var contactError = false

    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedColor = Color(red: 0.46, green: 0.48, blue: 0.5)
    private let genders = ["Male", "Female", "Other"]

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    headerSection
                    photoPicker
                    formCard
                    submitButton
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: – Header

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Complete Your Profile")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            Text("Tell us a little about yourself so we can personalise your experience.")
                .font(.system(size: 14))
                .foregroundStyle(mutedColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }

    // MARK: – Photo picker

    private var photoPicker: some View {
        VStack(spacing: 10) {
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                Circle()
                                    .fill(brandColor.opacity(0.15))
                                Image(systemName: "person.fill")
                                    .font(.system(size: 46))
                                    .foregroundStyle(brandColor.opacity(0.7))
                            }
                        }
                    }
                    .frame(width: 104, height: 104)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 3))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)

                    Circle()
                        .fill(brandColor)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(.white)
                        )
                        .offset(x: 2, y: 2)
                }
            }
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) {
                        profileImage = img
                    }
                }
            }

            Text("Tap to add photo")
                .font(.system(size: 12))
                .foregroundStyle(mutedColor)
        }
    }

    // MARK: – Form card

    private var formCard: some View {
        VStack(spacing: 0) {
            formField(
                icon: "person.fill",
                placeholder: "Full name",
                text: $name,
                keyboard: .default,
                hasError: nameError
            )

            divider

            formField(
                icon: "phone.fill",
                placeholder: "Contact number",
                text: $contactNumber,
                keyboard: .phonePad,
                hasError: contactError
            )

            divider

            formField(
                icon: "envelope.fill",
                placeholder: "Email address",
                text: $email,
                keyboard: .emailAddress,
                hasError: false
            )

            divider

            genderRow
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    private func formField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType,
        hasError: Bool
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(hasError ? .red : brandColor)
                .frame(width: 22)

            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .autocorrectionDisabled()
                .font(.system(size: 15))

            if hasError {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
    }

    private var divider: some View {
        Divider().padding(.leading, 50)
    }

    private var genderRow: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 15))
                .foregroundStyle(brandColor)
                .frame(width: 22)

            Text("Gender")
                .font(.system(size: 15))
                .foregroundStyle(textColor)

            Spacer()

            HStack(spacing: 6) {
                ForEach(genders, id: \.self) { option in
                    Button {
                        gender = option
                    } label: {
                        Text(option)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(gender == option ? .white : mutedColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(gender == option ? brandColor : Color.gray.opacity(0.1))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: – Submit

    private var submitButton: some View {
        Button(action: submit) {
            Text("Get Started")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [brandColor, brandColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: brandColor.opacity(0.4), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    private func submit() {
        nameError = name.trimmingCharacters(in: .whitespaces).isEmpty
        contactError = contactNumber.trimmingCharacters(in: .whitespaces).isEmpty

        guard !nameError, !contactError else { return }

        controller.saveUserProfile(
            UserProfile(
                name: name.trimmingCharacters(in: .whitespaces),
                contactNumber: contactNumber.trimmingCharacters(in: .whitespaces),
                email: email.trimmingCharacters(in: .whitespaces),
                gender: gender,
                photo: profileImage
            )
        )
    }
}

#Preview {
    ProfileSetupView(controller: QueueController())
}
