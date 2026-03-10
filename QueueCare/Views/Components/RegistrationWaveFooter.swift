import SwiftUI

struct RegistrationWaveFooter: View {
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            WaveShape()
                .fill(color.opacity(0.78))
                .frame(height: 82)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(color.opacity(0.78))
                        .frame(height: 42)
                }

            Text("Having trouble? Visit the front desk\nfor assistance")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.55, green: 0.48, blue: 0.45))
                .padding(.bottom, 12)
        }
    }
}

private struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.55))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.22, y: rect.height * 0.48),
            control1: CGPoint(x: rect.width * 0.05, y: rect.height * 0.32),
            control2: CGPoint(x: rect.width * 0.14, y: rect.height * 0.67)
        )
        path.addCurve(
            to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.56),
            control1: CGPoint(x: rect.width * 0.31, y: rect.height * 0.28),
            control2: CGPoint(x: rect.width * 0.41, y: rect.height * 0.75)
        )
        path.addCurve(
            to: CGPoint(x: rect.width * 0.76, y: rect.height * 0.5),
            control1: CGPoint(x: rect.width * 0.6, y: rect.height * 0.35),
            control2: CGPoint(x: rect.width * 0.67, y: rect.height * 0.68)
        )
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.52),
            control1: CGPoint(x: rect.width * 0.86, y: rect.height * 0.26),
            control2: CGPoint(x: rect.width * 0.94, y: rect.height * 0.74)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    RegistrationWaveFooter(color: Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255))
        .background(Color(red: 0.94, green: 0.97, blue: 0.97))
}
