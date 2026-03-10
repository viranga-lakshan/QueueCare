import Foundation

struct DepartmentCatalog {
    let options: [DepartmentOption]

    static let sample = DepartmentCatalog(
        options: [
            DepartmentOption(title: "General OPD", imageName: "generalOPD", theme: .blue),
            DepartmentOption(title: "Pediatrics", imageName: "pediatrics", theme: .purple),
            DepartmentOption(title: "Cardiology", imageName: "cardiology", theme: .coral),
            DepartmentOption(title: "Ophthalmology", imageName: "Ophthalmology", theme: .blue)
        ]
    )
}

struct DepartmentOption: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let theme: DepartmentAccentTheme
}

enum DepartmentAccentTheme {
    case blue
    case purple
    case coral
}