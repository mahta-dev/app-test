import Foundation
import Combine
@testable import app_challenge

class MockURLShortenerViewModel: URLShortenerViewModelProtocol, ObservableObject {
    @Published var inputText: String = ""
    @Published var state: URLShortenerViewState = .idle
    
    private let _actions = PassthroughSubject<URLShortenerAction, Never>()
    var actions: AnyPublisher<URLShortenerAction, Never> {
        _actions.eraseToAnyPublisher()
    }
    
    func handle(_ action: URLShortenerAction) {
        _actions.send(action)
    }
    
    static func idleState() -> MockURLShortenerViewModel {
        let viewModel = MockURLShortenerViewModel()
        viewModel.state = .idle
        return viewModel
    }
    
    static func loadingState() -> MockURLShortenerViewModel {
        let viewModel = MockURLShortenerViewModel()
        viewModel.state = .loading
        return viewModel
    }
    
    static func successState() -> MockURLShortenerViewModel {
        let viewModel = MockURLShortenerViewModel()
        let mockURLs = [
            ShortenedURLEntity(
                id: "1",
                originalURL: "https://www.google.com",
                shortURL: "https://short.ly/abc123",
                alias: "abc123"
            ),
            ShortenedURLEntity(
                id: "2",
                originalURL: "https://www.apple.com",
                shortURL: "https://short.ly/def456",
                alias: "def456"
            )
        ]
        viewModel.state = .success(mockURLs)
        return viewModel
    }
    
    static func errorState() -> MockURLShortenerViewModel {
        let viewModel = MockURLShortenerViewModel()
        let error = URLShortenerError.networkError("Connection failed")
        viewModel.state = .error(error)
        return viewModel
    }
    
    static func withInput(_ text: String) -> MockURLShortenerViewModel {
        let viewModel = MockURLShortenerViewModel()
        viewModel.inputText = text
        return viewModel
    }
}
