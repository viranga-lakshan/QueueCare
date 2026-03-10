import SwiftUI
import UIKit

struct WelcomeHeroView: View {
    let imageName: String
    let accentColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.4))
                .overlay(
                    Circle()
                        .stroke(accentColor.opacity(0.42), lineWidth: 1.4)
                )
                .shadow(color: accentColor.opacity(0.08), radius: 30, x: 0, y: 12)

            Circle()
                .fill(.white.opacity(0.78))
                .frame(width: 192, height: 192)
                .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 10)

            heroImage
                .frame(width: 188, height: 188)
                .shadow(color: accentColor.opacity(0.1), radius: 12, x: 0, y: 8)

            Circle()
                .fill(accentColor.opacity(0.18))
                .frame(width: 18, height: 18)
                .offset(x: 96, y: 70)

            Circle()
                .fill(accentColor)
                .frame(width: 10, height: 10)
                .offset(x: -84, y: -82)
        }
        .frame(width: 284, height: 284)
    }

    @ViewBuilder
    private var heroImage: some View {
        if let path = Bundle.main.path(forResource: imageName, ofType: "png", inDirectory: "Resources/Images"),
           let uiImage = UIImage(contentsOfFile: path) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "cross.case.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(accentColor)
                .padding(28)
        }
    }
}

#Preview {
    WelcomeHeroView(imageName: "Ellipse 2", accentColor: Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255))
        .padding()
        .background(Color(red: 0.94, green: 0.97, blue: 0.97))
}
