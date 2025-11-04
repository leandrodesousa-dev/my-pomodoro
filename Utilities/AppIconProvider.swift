import UIKit

enum AppIconProvider {
    static func primaryAppIcon() -> UIImage? {
        guard
            let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last,
            let iconImage = UIImage(named: lastIcon)
        else {
            return nil
        }
        return iconImage
    }
}


