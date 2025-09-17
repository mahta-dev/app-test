import Foundation

@MainActor
protocol URLShortenerFactoryManagerProtocol {
    func createURLShortenerView() -> URLShortenerMainView<URLShortenerViewModel>
}

@MainActor
final class URLShortenerFactoryManager: URLShortenerFactoryManagerProtocol {
    private let factory: URLShortenerFactoryProtocol
    
    init(factory: URLShortenerFactoryProtocol) {
        self.factory = factory
    }
    
    func createURLShortenerView() -> URLShortenerMainView<URLShortenerViewModel> {
        return factory.createURLShortenerView()
    }
}
