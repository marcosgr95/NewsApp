import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    private let netClient: NetworkService

    @Published var newsViewModel: NewsViewModel!
    @Published var newsDetailViewModel: NewsDetailViewModel?

    init(netClient: NetworkService) {
        self.netClient = netClient
        self.newsViewModel = NewsViewModel(netClient: netClient, coordinator: self)
    }

    func navigateToNewsDetail(news: NewsModel) {
        self.newsDetailViewModel = NewsDetailViewModel(news: news, netClient: netClient, coordinator: self)
    }
}

struct AppCoordinatorView: View {
    let netClient: NetworkService

    @ObservedObject var coordinator: AppCoordinator

    init(netClient: NetworkService) {
        self.netClient = netClient
        self.coordinator = AppCoordinator(netClient: netClient)
    }

    var body: some View {
        NavigationView {
            NewsList(viewModel: coordinator.newsViewModel)
                .navigation(viewModel: $coordinator.newsDetailViewModel) { viewModel in
                    NewsDetail(viewModel: viewModel)
                }
        }
    }
}
