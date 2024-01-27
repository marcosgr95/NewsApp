import Foundation
import Combine

enum NetError: Error {
    enum RequestFailureReason { case wrongHTTPStatusCode(Int), noInnerState, failedDecoding, noContent, apiRelated(String), unknown }
    case invalidURL, requestFailure(RequestFailureReason)
}
enum HTTPMethod: String { case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE" }
enum QueryItem: String { case countryID = "country", searchText = "q", pageIndex = "page", pageSize = "pageSize", apiKey = "apiKey" }

enum Endpoint {
    /**
     API Key discussion:
     
     The API key should never be stored this way. I'm deciding to store it here for simplicity's sake, since the evaluators will have to download the project to try it and it's way easier to have a project that's ready to run immediately.

     I could have followed two main alternatives to this one:
     1. Store it in a server (or in Firebase) and retrieve it when the app is opened.
     2. Store it in a local file that's never uploaded to the repo. However, if we're working with a team this file should be distributed in some way during the onboarding, with a bootstrap file, via an automated process, etc.
     
     */
    static let apiKey = "84e1128d271d45e8b0e7826654608401"

    static let baseURL: String = "https://newsapi.org" // This'll do for this exercise, but it wouldn't work for a multi-environment app

    case topHeadlines // In a fully-fledged app we'd expect to have more cases here

    var path: String {
        switch self {
        case .topHeadlines: "/v2/top-headlines"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .topHeadlines: .get
        }
    }
}

protocol NetworkService {
    func request<T: Decodable>(endpoint: Endpoint, query: [QueryItem: String?]) -> AnyPublisher<T, NetError>
}

struct ResponseWrapper<T: Decodable>: Decodable {
    let status: String?
    let errorMessage: String?
    let totalResults: Int?
    let content: T?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case errorMessage = "message"
        case totalResults = "totalResults"
        case content = "articles"
    }
}
