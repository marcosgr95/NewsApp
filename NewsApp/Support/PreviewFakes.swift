import Foundation
import Combine

let fakeNews = NewsModel(
    author: "Jason Schreier",
    title: "Video-Game Companies Make Workers Relocate, Then Fire Them",
    source: NewsModel.Source(name: "Bloomberg"),
    description: "Return-to-office policies are mixing with the inherent volatility of the gaming industry with painful results",
    url: "https://www.bloomberg.com/news/newsletters/2024-01-26/video-game-companies-make-workers-relocate-then-fire-them?embedded-checkout=true",
    imageUrl: "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iORuKt6DWr5Q/v0/-1x-1.jpg"
)

class FakeNetClient: NetworkService {
    func request<T>(endpoint: Endpoint, query: [QueryItem: String?]) -> AnyPublisher<T, NetError> where T: Decodable {
        PassthroughSubject<T, NetError>().eraseToAnyPublisher()
    }
}

class FakeCoordinator: Coordinator {
    func navigateToNewsDetail(news: NewsModel) {}
    func popDetail() {}
}

class FakeNewsInteractor: NewsInteractorProtocol {
    func getTopNews(_ newsQuery: NewsQuery) -> AnyPublisher<[NewsModel], NetError> {
        CurrentValueSubject([fakeNews, fakeNews]).eraseToAnyPublisher()
    }
}
