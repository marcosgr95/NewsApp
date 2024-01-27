import Foundation
import Combine

struct NewsModel: Identifiable, Decodable {
    let id: Int = UUID().hashValue

    struct Source: Decodable {
        let name: String
    }
    let author: String?
    let title: String
    let source: Source?
    let description: String?
    let url: String?
    let imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case source = "source"
        case description = "description"
        case url = "url"
        case imageUrl = "urlToImage"
    }
}

struct NewsQuery {
    let page: Int
    var pageSize: Int = 20
    var country: String = "us"
    var searchText: String?
}

extension NewsQuery {
    func asRequestQuery() -> [QueryItem: String?] {
        [
            QueryItem.pageIndex: page.toString(),
            QueryItem.pageSize: pageSize.toString(),
            QueryItem.countryID: country,
            QueryItem.searchText: searchText
        ]
    }
}

final class NewsInteractor: BaseInteractor {
    var netClient: NetworkService

    init(netClient: NetworkService) {
        self.netClient = netClient
    }

    func getTopNews(_ newsQuery: NewsQuery) -> AnyPublisher<[NewsModel], NetError> {
        netClient.request(endpoint: .topHeadlines, query: newsQuery.asRequestQuery())
    }
}
