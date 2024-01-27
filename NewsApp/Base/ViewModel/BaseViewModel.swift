import Foundation

protocol BaseViewModel: ObservableObject {
    associatedtype NS = NetworkService
    associatedtype BI = BaseInteractor

    var netClient: NS { get }
    var interactor: BI { get }
}
