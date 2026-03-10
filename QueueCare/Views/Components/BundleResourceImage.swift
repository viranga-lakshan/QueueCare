import SwiftUI
import UIKit

struct BundleResourceImage: View {
    let name: String
    var subdirectory: String? = nil
    var isTemplate = false
    var fallbackSystemName = "photo"

    var body: some View {
        Group {
            if let uiImage = BundleResourceImageLoader.image(named: name, subdirectory: subdirectory) {
                if isTemplate {
                    Image(uiImage: uiImage.withRenderingMode(.alwaysTemplate))
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: fallbackSystemName)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

enum BundleResourceImageLoader {
    static func image(named name: String, subdirectory: String? = nil) -> UIImage? {
        let directories = [
            subdirectory.map { "Resources/Images/\($0)" },
            "Resources/Images"
        ].compactMap { $0 }

        for directory in directories {
            for fileExtension in ["png", "jpg", "jpeg"] {
                guard let path = Bundle.main.path(forResource: name, ofType: fileExtension, inDirectory: directory) else {
                    continue
                }

                if let image = UIImage(contentsOfFile: path) {
                    return image
                }
            }
        }

        return nil
    }
}