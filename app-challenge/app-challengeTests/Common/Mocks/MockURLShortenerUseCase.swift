import Foundation
@testable import app_challenge

@MainActor
class MockURLShortenerUseCase: URLShortenerUseCaseProtocol {
    var shortenURLCalled = false
    var shortenURLResult: Result<ShortenedURLEntity, Error> = .failure(TestError.mockError)
    
    var resolveURLCalled = false
    var resolveURLCallCount = 0
    var lastResolveURLAlias: String?
    var resolveURLResult: Result<String, Error> = .failure(TestError.mockError)
    
    var getShortenedURLsCalled = false
    var getShortenedURLsResult: Result<[ShortenedURLEntity], Error> = .failure(TestError.mockError)
    
    var deleteURLCalled = false
    var lastDeleteURLId: String?
    var deleteURLResult: Result<Void, Error> = .failure(TestError.mockError)
    
    func shortenURL(_ url: URL) async throws -> ShortenedURLEntity {
        shortenURLCalled = true
        
        switch shortenURLResult {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        }
    }
    
    func resolveURL(alias: String) async throws -> String {
        resolveURLCalled = true
        resolveURLCallCount += 1
        lastResolveURLAlias = alias
        
        switch resolveURLResult {
        case .success(let url):
            return url
        case .failure(let error):
            throw error
        }
    }
    
    func getShortenedURLs() async throws -> [ShortenedURLEntity] {
        getShortenedURLsCalled = true
        
        switch getShortenedURLsResult {
        case .success(let urls):
            return urls
        case .failure(let error):
            throw error
        }
    }
    
    func deleteShortenedURL(id: String) async throws {
        deleteURLCalled = true
        lastDeleteURLId = id
        
        switch deleteURLResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
