import Foundation

protocol URLShortenerRepositoryProtocol {
    func shortenURL(_ url: URL) async throws -> ShortenedURLEntity
    func resolveURL(alias: String) async throws -> String
    func getShortenedURLs() async throws -> [ShortenedURLEntity]
    func deleteShortenedURL(id: String) async throws
}
