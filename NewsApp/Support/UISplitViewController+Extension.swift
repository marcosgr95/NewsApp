import UIKit

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        self.preferredSplitBehavior = .displace
    }
}
