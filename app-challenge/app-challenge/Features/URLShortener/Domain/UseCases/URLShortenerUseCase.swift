import Foundation

protocol URLShortenerUseCaseProtocol {
    func shortenURL(_ url: URL) async throws -> ShortenedURLEntity
    func resolveURL(alias: String) async throws -> String
    func getShortenedURLs() async throws -> [ShortenedURLEntity]
    func deleteShortenedURL(id: String) async throws
}

final class URLShortenerUseCase: URLShortenerUseCaseProtocol {
    private let repository: URLShortenerRepositoryProtocol
    private var cache: [String: ShortenedURLEntity] = [:]
    private var recentURLs: [ShortenedURLEntity] = []
    
    init(repository: URLShortenerRepositoryProtocol) {
        self.repository = repository
    }
    
    func shortenURL(_ url: URL) async throws -> ShortenedURLEntity {
        let urlString = url.absoluteString
        
        if let cached = cache[urlString] {
            return cached
        }
        
        try validateURLForShortening(url)
        
        let shortenedURL = try await repository.shortenURL(url)
        
        cache[urlString] = shortenedURL
        addToRecentURLs(shortenedURL)
        
        return shortenedURL
    }
    
    func resolveURL(alias: String) async throws -> String {
        try validateAlias(alias)
        
        return try await repository.resolveURL(alias: alias)
    }
    
    func getShortenedURLs() async throws -> [ShortenedURLEntity] {
        return recentURLs.sorted { $0.createdAt > $1.createdAt }
    }
    
    func deleteShortenedURL(id: String) async throws {
        guard let urlToDelete = recentURLs.first(where: { $0.id == id }) else {
            throw URLShortenerError.urlNotFound
        }
        
        try await repository.deleteShortenedURL(id: id)
        
        cache.removeValue(forKey: urlToDelete.originalURL)
        recentURLs.removeAll { $0.id == id }
    }
    
    private func validateURLForShortening(_ url: URL) throws {
        let urlString = url.absoluteString
        
        guard urlString.hasPrefix("http://") || urlString.hasPrefix("https://") else {
            throw URLShortenerError.invalidURLFormat
        }
        
        guard let urlComponents = URLComponents(string: urlString),
              let scheme = urlComponents.scheme,
              let host = urlComponents.host else {
            throw URLShortenerError.invalidURLFormat
        }
        
        guard scheme == "http" || scheme == "https" else {
            throw URLShortenerError.invalidURLFormat
        }
        
        guard !host.isEmpty else {
            throw URLShortenerError.invalidURLFormat
        }
        
        if urlString.count > 2048 {
            throw URLShortenerError.urlTooLong
        }
        
        if urlString.contains("url-shortener-server.onrender.com") {
            throw URLShortenerError.circularShortening
        }
    }
    
    private func validateAlias(_ alias: String) throws {
        guard !alias.isEmpty else {
            throw URLShortenerError.invalidAlias
        }
        
        let allowedCharacters = CharacterSet.alphanumerics
        guard alias.rangeOfCharacter(from: allowedCharacters.inverted) == nil else {
            throw URLShortenerError.invalidAliasFormat
        }
    }
    
    private func addToRecentURLs(_ url: ShortenedURLEntity) {
        recentURLs.removeAll { $0.id == url.id }
        
        recentURLs.insert(url, at: 0)
        
        if recentURLs.count > 50 {
            recentURLs = Array(recentURLs.prefix(50))
        }
    }
}


enum URLShortenerError: LocalizedError {
    case invalidURLFormat
    case urlTooLong
    case circularShortening
    case invalidAlias
    case invalidAliasFormat
    case urlNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURLFormat:
            return "URL must start with http:// or https://"
        case .urlTooLong:
            return "URL is too long (maximum 2048 characters)"
        case .circularShortening:
            return "Cannot shorten an already shortened URL"
        case .invalidAlias:
            return "Alias cannot be empty"
        case .invalidAliasFormat:
            return "Alias must contain only alphanumeric characters"
        case .urlNotFound:
            return "URL not found"
        }
    }
}
