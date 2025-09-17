import Foundation
import Combine

@MainActor
final class URLShortenerDetailViewModel: URLShortenerDetailViewModelProtocol {
    @Published var resolvedURL: String?
    @Published var isResolving: Bool = false
    @Published var resolveError: String?
    
    private let useCase: URLShortenerUseCaseProtocol
    
    init(useCase: URLShortenerUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func handle(_ action: URLShortenerDetailAction) {
        switch action {
        case .resolveURL(let alias):
            resolveURL(alias: alias)
        case .clearError:
            clearError()
        }
    }
    
    private func resolveURL(alias: String) {
        isResolving = true
        resolveError = nil
        resolvedURL = nil
        
        Task {
            do {
                let originalURL = try await useCase.resolveURL(alias: alias)
                resolvedURL = originalURL
                isResolving = false
            } catch {
                resolveError = error.localizedDescription
                isResolving = false
            }
        }
    }
    
    private func clearError() {
        resolveError = nil
    }
}
