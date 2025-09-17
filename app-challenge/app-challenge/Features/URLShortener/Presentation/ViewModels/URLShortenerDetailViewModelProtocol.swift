import Foundation

enum URLShortenerDetailAction {
    case resolveURL(String)
    case clearError
}

@MainActor
protocol URLShortenerDetailViewModelProtocol: ObservableObject {
    var resolvedURL: String? { get }
    var isResolving: Bool { get }
    var resolveError: String? { get }
    
    func handle(_ action: URLShortenerDetailAction)
}
