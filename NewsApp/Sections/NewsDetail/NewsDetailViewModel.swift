import SwiftUI
import Combine

final class NewsDetailViewModel: ObservableObject {
    @Published var news: NewsModel
    let netClient: NetworkService
    let coordinator: AppCoordinator

    private var cancellables: Set<AnyCancellable> = []

    init(news: NewsModel, netClient: NetworkService, coordinator: AppCoordinator) {
        self.news = news
        self.netClient = netClient
        self.coordinator = coordinator
    }
}
