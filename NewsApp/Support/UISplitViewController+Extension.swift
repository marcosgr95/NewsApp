import UIKit

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.presentsWithGesture = false
        self.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        self.preferredSplitBehavior = .displace
    }
}
