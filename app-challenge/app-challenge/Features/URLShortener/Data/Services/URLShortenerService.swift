import Foundation
import Network

public protocol URLShortenerServiceProtocol: Sendable {
    func shortenURL(_ url: URL) async throws -> ShortenResponse
    func resolveURL(alias: String) async throws -> ResolveResponse
}

public final class URLShortenerService: URLShortenerServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public init(requestManager: RequestManagerProtocol = RequestManager(baseURL: "https://url-shortener-server.onrender.com")) {
        self.requestManager = requestManager
    }
    public func shortenURL(_ url: URL) async throws -> ShortenResponse {
        let endpoint = ShortAPI.create(url: url)
        return try await requestManager.request(endpoint: endpoint)
    }
    
    public func resolveURL(alias: String) async throws -> ResolveResponse {
        let endpoint = ShortAPI.resolve(alias: alias)
        return try await requestManager.request(endpoint: endpoint)
    }
}
