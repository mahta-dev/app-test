import Foundation
import Combine

@MainActor
final class URLShortenerViewModel: URLShortenerViewModelProtocol {
    @Published var state: URLShortenerViewState = .idle
    @Published var inputText: String = ""
    
    private let useCase: URLShortenerUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: URLShortenerUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func handle(_ action: URLShortenerAction) {
        switch action {
        case .shortenURL(let urlString):
            shortenURL(urlString)
        case .loadShortenedURLs:
            loadShortenedURLs()
        case .deleteURL(let id):
            deleteURL(id: id)
        case .clearError:
            clearError()
        case .refresh:
            refresh()
        }
    }
    
    private func shortenURL(_ urlString: String) {
        guard !urlString.isEmpty else { return }
        
        guard urlString.isValidURL else {
            state = .error(URLShortenerErrorModel(
                message: "Please enter a valid URL (e.g., https://example.com)",
                retryAction: nil
            ))
            return
        }
        
        let normalizedURL = urlString.normalizedURL()
        
        guard let url = URL(string: normalizedURL) else {
            state = .error(URLShortenerErrorModel(
                message: "Invalid URL format",
                retryAction: nil
            ))
            return
        }
        
        state = .loading
        
        Task {
            do {
                let _ = try await useCase.shortenURL(url)
                inputText = ""
                loadShortenedURLs()
            } catch {
                state = .error(URLShortenerErrorModel(
                    message: error.localizedDescription,
                    retryAction: { [weak self] in
                        self?.handle(.shortenURL(urlString))
                    }
                ))
            }
        }
    }
    
    private func loadShortenedURLs() {
        Task {
            do {
                let urls = try await useCase.getShortenedURLs()
                state = .success(urls)
            } catch {
                state = .error(URLShortenerErrorModel(
                    message: error.localizedDescription,
                    retryAction: { [weak self] in
                        self?.handle(.loadShortenedURLs)
                    }
                ))
            }
        }
    }
    
    private func deleteURL(id: String) {
        Task {
            do {
                try await useCase.deleteShortenedURL(id: id)
                loadShortenedURLs()
            } catch {
                state = .error(URLShortenerErrorModel(
                    message: error.localizedDescription,
                    retryAction: nil
                ))
            }
        }
    }
    
    private func clearError() {
        if case .error = state {
            state = .idle
        }
    }
    
    private func refresh() {
        loadShortenedURLs()
    }
}
