import SwiftUI
import UIKit

final class PortraitHostingController<Content: View>: UIHostingController<Content> {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

struct PortraitSettingsContainer<Content: View>: UIViewControllerRepresentable {
    let rootView: Content
    
    func makeUIViewController(context: Context) -> UIViewController {
        PortraitHostingController(rootView: rootView)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let hosting = uiViewController as? PortraitHostingController<Content> {
            hosting.rootView = rootView
        }
    }
}


