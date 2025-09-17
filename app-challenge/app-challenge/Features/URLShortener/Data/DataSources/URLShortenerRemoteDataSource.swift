import Foundation
import Network

protocol URLShortenerDataSourceProtocol {
    func shortenURL(_ url: URL) async throws -> ShortenResponse
    func resolveURL(alias: String) async throws -> ResolveResponse
}

final class URLShortenerRemoteDataSource: URLShortenerDataSourceProtocol {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func shortenURL(_ url: URL) async throws -> ShortenResponse {
        let endpoint = ShortAPI.create(url: url)
        return try await requestManager.request(endpoint: endpoint)
    }
    
    func resolveURL(alias: String) async throws -> ResolveResponse {
        let endpoint = ShortAPI.resolve(alias: alias)
        return try await requestManager.request(endpoint: endpoint)
    }
}
