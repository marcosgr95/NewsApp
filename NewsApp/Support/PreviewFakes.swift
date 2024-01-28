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

let fakeNews2 = NewsModel(
    author: "Liam Doolan",
    title: "Microsoft Lays Off 1,900 Xbox, Bethesda And Activision Blizzard Employees",
    source: NewsModel.Source(name: "NintendoLife"),
    description: """
    Some more industry news has broken this week, and this time it relates to Microsoft's Xbox division,
    which last year finalised its acquisition of Activision Blizzard and has in recent times reiterated its support for Nintendo platforms.

    In a message from the Xbox and Microsoft gaming boss Phil Spencer (via IGN),
    it's been revealed 1,900 roles out of 22,000 in total across the team have been axed.

    This includes many roles within ZeniMax (Bethesda) and Activision Blizzard.
    The reasoning behind this is so the leadership of the business aligns on a "strategy and an execution plan with a
    sustainable cost structure" that will support the whole of the growing business. Here's the full statement from Phil:
    """
    ,
    url: "https://www.nintendolife.com/news/2024/01/microsoft-lays-off-1900-xbox-bethesda-and-activision-blizzard-employees",
    imageUrl: "https://images.nintendolife.com/463e828d12914/xbox.large.jpg"
)

class FakeNetClient: NetworkService {
    func request<T>(endpoint: Endpoint, query: [QueryItem: String?]) -> AnyPublisher<T, NetError> where T: Decodable {
        PassthroughSubject<T, NetError>().eraseToAnyPublisher()
    }
}

class FakeCoordinator: Coordinator {
    func navigateToNewsDetail(news: NewsModel) {}
    func popDetail() {}
    func seeOnSafari(url: URL) {}
}

class FakeNewsInteractor: NewsInteractorProtocol {
    func getTopNews(_ newsQuery: NewsQuery) -> AnyPublisher<[NewsModel], NetError> {
        CurrentValueSubject([fakeNews, fakeNews2]).eraseToAnyPublisher()
    }
}
