import Foundation
import Combine

enum APODAction {
    case loadAPOD(date: String)
    case loadRandomAPOD
    case clearError
    case refresh
}

protocol APODViewModelProtocol: ObservableObject {
    var state: APODViewState { get }
    
    func handle(_ action: APODAction)
}
