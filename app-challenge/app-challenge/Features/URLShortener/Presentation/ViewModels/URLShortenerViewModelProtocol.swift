import Foundation
import Combine

enum URLShortenerAction {
    case shortenURL(String)
    case loadShortenedURLs
    case deleteURL(String)
    case clearError
    case refresh
}

@MainActor
protocol URLShortenerViewModelProtocol: ObservableObject {
    var state: URLShortenerViewState { get }
    var inputText: String { get set }
    
    func handle(_ action: URLShortenerAction)
}
