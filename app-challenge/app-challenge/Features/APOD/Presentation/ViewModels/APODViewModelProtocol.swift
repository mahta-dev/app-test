import Foundation
import Combine

enum APODAction {
    case loadAPOD(date: String)
    case loadRandomAPOD
    case clearError
    case refresh
}

protocol APODViewModelProtocol: ObservableObject {
    var apod: APODEntity? { get }
    var isLoading: Bool { get }
    var error: APODErrorModel? { get }
    var isEmpty: Bool { get }
    
    func handle(_ action: APODAction)
}
