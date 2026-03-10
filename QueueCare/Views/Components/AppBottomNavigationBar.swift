import SwiftUI

struct AppBottomNavigationBar: View {
    let selectedTab: DashboardTab
    let accentColor: Color
    let action: (DashboardTab) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(DashboardTab.allCases) { tab in
                Button {
                    action(tab)
                } label: {
                    VStack(spacing: 6) {
                        BundleResourceImage(
                            name: tab.imageName,
                            subdirectory: "navbar",
                            isTemplate: true,
                            fallbackSystemName: tab.fallbackSystemName
                        )
                        .frame(width: 22, height: 22)
                        .foregroundStyle(selectedTab == tab ? accentColor : Color.black.opacity(0.82))

                        Text(tab.title)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(selectedTab == tab ? accentColor : Color.black.opacity(0.82))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}

#Preview {
    AppBottomNavigationBar(selectedTab: .home, accentColor: Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)) { _ in }
        .padding()
        .background(Color(red: 0.92, green: 0.95, blue: 0.95))
}