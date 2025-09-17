import Foundation

final class URLShortenerRepository: URLShortenerRepositoryProtocol {
    private let dataSource: URLShortenerDataSourceProtocol
    private var shortenedURLs: [ShortenedURLEntity] = []
    
    init(dataSource: URLShortenerDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func shortenURL(_ url: URL) async throws -> ShortenedURLEntity {
        let response = try await dataSource.shortenURL(url)
        
        let entity = ShortenedURLEntity(
            id: UUID().uuidString,
            originalURL: url.absoluteString,
            shortURL: response._links.short.absoluteString,
            alias: response.alias,
            createdAt: Date()
        )
        
        shortenedURLs.insert(entity, at: 0)
        return entity
    }
    
    func resolveURL(alias: String) async throws -> String {
        let response = try await dataSource.resolveURL(alias: alias)
        return response.url.absoluteString
    }
    
    func getShortenedURLs() async throws -> [ShortenedURLEntity] {
        return shortenedURLs
    }
    
    func deleteShortenedURL(id: String) async throws {
        shortenedURLs.removeAll { $0.id == id }
    }
}
