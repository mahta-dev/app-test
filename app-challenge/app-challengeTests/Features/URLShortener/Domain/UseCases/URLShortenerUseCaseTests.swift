import XCTest
@testable import app_challenge

final class URLShortenerUseCaseTests: XCTestCase {
    
    var useCase: URLShortenerUseCase!
    var mockRepository: MockURLShortenerRepository!
    
    override func setUpWithError() throws {
        mockRepository = MockURLShortenerRepository()
        useCase = URLShortenerUseCase(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        useCase = nil
        mockRepository = nil
    }
    
    func testShortenURL_Success() async throws {
        let url = URL(string: "https://example.com")!
        let expectedEntity = ShortenedURLEntity(
            id: "test-id",
            originalURL: url.absoluteString,
            shortURL: "https://short.ly/abc123",
            alias: "abc123",
            createdAt: Date()
        )
        mockRepository.shortenURLResult = .success(expectedEntity)
        
        let result = try await useCase.shortenURL(url)
        
        XCTAssertEqual(result.id, expectedEntity.id)
        XCTAssertEqual(result.originalURL, expectedEntity.originalURL)
        XCTAssertEqual(result.shortURL, expectedEntity.shortURL)
        XCTAssertEqual(result.alias, expectedEntity.alias)
        XCTAssertTrue(mockRepository.shortenURLCalled)
    }
    
    func testShortenURL_CacheHit() async throws {
        let url = URL(string: "https://example.com")!
        let cachedEntity = ShortenedURLEntity(
            id: "cached-id",
            originalURL: url.absoluteString,
            shortURL: "https://short.ly/cached",
            alias: "cached",
            createdAt: Date()
        )
        mockRepository.shortenURLResult = .success(cachedEntity)
        
        _ = try await useCase.shortenURL(url)
        
        let result = try await useCase.shortenURL(url)
        
        XCTAssertEqual(result.id, cachedEntity.id)
        XCTAssertEqual(mockRepository.shortenURLCallCount, 1)
    }
    
    func testShortenURL_InvalidURLFormat() async throws {
        let url = URL(string: "ftp://invalid.com")!
        
        do {
            _ = try await useCase.shortenURL(url)
            XCTFail("Should throw invalidURLFormat error")
        } catch URLShortenerError.invalidURLFormat {
        } catch {
            XCTFail("Should throw invalidURLFormat error, got: \(error)")
        }
    }
    
    func testShortenURL_URITooLong() async throws {
        let longURL = "https://example.com/" + String(repeating: "a", count: 2100)
        let url = URL(string: longURL)!
        
        XCTAssertGreaterThan(url.absoluteString.count, 2048)
        
        do {
            _ = try await useCase.shortenURL(url)
            XCTFail("Should throw urlTooLong error")
        } catch URLShortenerError.urlTooLong {
            XCTAssertFalse(mockRepository.shortenURLCalled)
        } catch {
            XCTFail("Should throw urlTooLong error, got: \(error)")
        }
    }
    
    func testShortenURL_CircularShortening() async throws {
        let url = URL(string: "https://url-shortener-server.onrender.com/api/test")!
        
        do {
            _ = try await useCase.shortenURL(url)
            XCTFail("Should throw circularShortening error")
        } catch URLShortenerError.circularShortening {
        } catch {
            XCTFail("Should throw circularShortening error, got: \(error)")
        }
    }
    
    func testResolveURL_Success() async throws {
        let alias = "abc123"
        let expectedURL = "https://example.com"
        mockRepository.resolveURLResult = .success(expectedURL)
        
        let result = try await useCase.resolveURL(alias: alias)
        
        XCTAssertEqual(result, expectedURL)
        XCTAssertTrue(mockRepository.resolveURLCalled)
        XCTAssertEqual(mockRepository.lastResolveURLAlias, alias)
    }
    
    func testResolveURL_InvalidAlias() async throws {
        let invalidAlias = ""
        
        do {
            _ = try await useCase.resolveURL(alias: invalidAlias)
            XCTFail("Should throw invalidAlias error")
        } catch URLShortenerError.invalidAlias {
        } catch {
            XCTFail("Should throw invalidAlias error, got: \(error)")
        }
    }
    
    func testResolveURL_InvalidAliasFormat() async throws {
        let invalidAlias = "abc-123!"
        
        do {
            _ = try await useCase.resolveURL(alias: invalidAlias)
            XCTFail("Should throw invalidAliasFormat error")
        } catch URLShortenerError.invalidAliasFormat {
        } catch {
            XCTFail("Should throw invalidAliasFormat error, got: \(error)")
        }
    }
    
    func testGetShortenedURLs_Success() async throws {
        let url1 = ShortenedURLEntity(
            id: "1",
            originalURL: "https://example1.com",
            shortURL: "https://short.ly/1",
            alias: "1",
            createdAt: Date().addingTimeInterval(-3600)
        )
        let url2 = ShortenedURLEntity(
            id: "2",
            originalURL: "https://example2.com",
            shortURL: "https://short.ly/2",
            alias: "2",
            createdAt: Date()
        )
        
        mockRepository.shortenURLResult = .success(url1)
        _ = try await useCase.shortenURL(URL(string: url1.originalURL)!)
        
        mockRepository.shortenURLResult = .success(url2)
        _ = try await useCase.shortenURL(URL(string: url2.originalURL)!)
        
        let result = try await useCase.getShortenedURLs()
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, "2")
        XCTAssertEqual(result.last?.id, "1")
    }
    
    func testDeleteShortenedURL_Success() async throws {
        let url = URL(string: "https://example.com")!
        let entity = ShortenedURLEntity(
            id: "test-id",
            originalURL: url.absoluteString,
            shortURL: "https://short.ly/test",
            alias: "test",
            createdAt: Date()
        )
        
        mockRepository.shortenURLResult = .success(entity)
        _ = try await useCase.shortenURL(url)
        
        mockRepository.deleteURLResult = .success(())
        
        try await useCase.deleteShortenedURL(id: "test-id")
        
        XCTAssertTrue(mockRepository.deleteURLCalled)
        XCTAssertEqual(mockRepository.lastDeleteURLId, "test-id")
    }
    
    func testDeleteShortenedURL_NotFound() async throws {
        let nonExistentId = "non-existent"
        
        do {
            try await useCase.deleteShortenedURL(id: nonExistentId)
            XCTFail("Should throw urlNotFound error")
        } catch URLShortenerError.urlNotFound {
        } catch {
            XCTFail("Should throw urlNotFound error, got: \(error)")
        }
    }
    
    func testDeleteShortenedURL_RepositoryError() async throws {
        let url = URL(string: "https://example.com")!
        let entity = ShortenedURLEntity(
            id: "test-id",
            originalURL: url.absoluteString,
            shortURL: "https://short.ly/test",
            alias: "test",
            createdAt: Date()
        )
        
        mockRepository.shortenURLResult = .success(entity)
        _ = try await useCase.shortenURL(url)
        
        mockRepository.deleteURLResult = .failure(TestError.deleteError)
        
        do {
            try await useCase.deleteShortenedURL(id: "test-id")
            XCTFail("Should throw delete error")
        } catch TestError.deleteError {
        } catch {
            XCTFail("Should throw delete error, got: \(error)")
        }
    }
    
    func testCacheManagement_Limit50URLs() async throws {
        for i in 0..<55 {
            let url = URL(string: "https://example\(i).com")!
            let entity = ShortenedURLEntity(
                id: "test-\(i)",
                originalURL: url.absoluteString,
                shortURL: "https://short.ly/test\(i)",
                alias: "test\(i)",
                createdAt: Date()
            )
            mockRepository.shortenURLResult = .success(entity)
            _ = try await useCase.shortenURL(url)
        }
        
        let result = try await useCase.getShortenedURLs()
        XCTAssertEqual(result.count, 50)
    }
}
