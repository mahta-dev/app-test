import Foundation
@testable import app_challenge

class MockURLShortenerDataSource: URLShortenerDataSourceProtocol {
    var shortenURLCalled = false
    var lastShortenURL: URL?
    var shortenURLResult: Result<ShortenResponse, Error> = .failure(TestError.mockError)
    
    var resolveURLCalled = false
    var lastResolveURLAlias: String?
    var resolveURLResult: Result<String, Error> = .failure(TestError.mockError)
    
    func shortenURL(_ url: URL) async throws -> ShortenResponse {
        shortenURLCalled = true
        lastShortenURL = url
        
        switch shortenURLResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func resolveURL(alias: String) async throws -> ResolveResponse {
        resolveURLCalled = true
        lastResolveURLAlias = alias
        
        switch resolveURLResult {
        case .success(let urlString):
            let url = URL(string: urlString)!
            return ResolveResponse(url: url)
        case .failure(let error):
            throw error
        }
    }
}
