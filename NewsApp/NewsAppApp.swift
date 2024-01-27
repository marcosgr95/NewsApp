import SwiftUI

@main
struct NewsAppApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(netClient: NewsAppClient())
        }
    }
}
