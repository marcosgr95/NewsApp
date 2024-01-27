import Foundation

protocol BaseInteractor {
    associatedtype NS = NetworkService

    var netClient: NS { get }
}
