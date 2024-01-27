import Foundation
import Combine

final class NewsAppClient: NetworkService {
    func request<T>(endpoint: Endpoint, query: [QueryItem: String?]) -> AnyPublisher<T, NetError> where T: Decodable {
        guard var urlComponents = URLComponents(string: Endpoint.baseURL + endpoint.path) else {
            return Fail(error: NetError.invalidURL).eraseToAnyPublisher()
        }

        urlComponents.queryItems = query.map { URLQueryItem(name: $0.rawValue, value: $1) }
            .reduce([URLQueryItem(name: QueryItem.apiKey.rawValue, value: Endpoint.apiKey)], {
                $0 + [$1]
            })

        guard let url = urlComponents.url else { return Fail(error: NetError.invalidURL).eraseToAnyPublisher() }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw NetError.requestFailure(.wrongHTTPStatusCode((response as? HTTPURLResponse)?.statusCode ?? Int.min))
                }
            }
            .decode(type: ResponseWrapper<T>.self, decoder: JSONDecoder())
            .tryMap { responseWrapper in
                guard let innerState = responseWrapper.status else { throw NetError.requestFailure(.noInnerState) }

                switch innerState {
                case "ok":
                    guard let content = responseWrapper.content else { throw NetError.requestFailure(.noContent) }
                    return content
                default:
                    let errorMessage = responseWrapper.errorMessage ?? "The request couldn't be completed due to an unexpected error"
                    throw NetError.requestFailure(.apiRelated(errorMessage))
                }
            }
            .mapError {
                if $0 is DecodingError {
                    return NetError.requestFailure(.failedDecoding)
                } else if let netError = $0 as? NetError {
                    return netError
                } else {
                    return NetError.requestFailure(.unknown)
                }
            }
            .eraseToAnyPublisher()
    }
}
