import XCTest
@testable import app_challenge

final class URLShortenerRepositoryTests: XCTestCase {
    
    var repository: URLShortenerRepository!
    var mockDataSource: MockURLShortenerDataSource!
    
    override func setUpWithError() throws {
        mockDataSource = MockURLShortenerDataSource()
        repository = URLShortenerRepository(dataSource: mockDataSource)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        mockDataSource = nil
    }
    
    func testShortenURL_Success() async throws {
        let url = URL(string: "https://example.com")!
        let mockResponse = ShortenResponse(
            alias: "abc123",
            _links: ShortenResponse.Links(
                self_: URL(string: "https://api.example.com/abc123")!,
                short: URL(string: "https://short.ly/abc123")!
            )
        )
        mockDataSource.shortenURLResult = .success(mockResponse)
        
        let result = try await repository.shortenURL(url)
        
        XCTAssertEqual(result.originalURL, url.absoluteString)
        XCTAssertEqual(result.shortURL, mockResponse._links.short.absoluteString)
        XCTAssertEqual(result.alias, mockResponse.alias)
        XCTAssertTrue(mockDataSource.shortenURLCalled)
        XCTAssertEqual(mockDataSource.lastShortenURL, url)
    }
    
    func testShortenURL_DataSourceError() async throws {
        let url = URL(string: "https://example.com")!
        mockDataSource.shortenURLResult = .failure(TestError.networkError)
        
        do {
            _ = try await repository.shortenURL(url)
            XCTFail("Should throw network error")
        } catch TestError.networkError {
        } catch {
            XCTFail("Should throw network error, got: \(error)")
        }
        XCTAssertTrue(mockDataSource.shortenURLCalled)
        XCTAssertEqual(mockDataSource.lastShortenURL, url)
    }
    
    func testResolveURL_Success() async throws {
        let alias = "abc123"
        let expectedURL = "https://example.com"
        mockDataSource.resolveURLResult = .success(expectedURL)
        
        let result = try await repository.resolveURL(alias: alias)
        
        XCTAssertEqual(result, expectedURL)
        XCTAssertTrue(mockDataSource.resolveURLCalled)
        XCTAssertEqual(mockDataSource.lastResolveURLAlias, alias)
    }
    
    func testResolveURL_DataSourceError() async throws {
        let alias = "abc123"
        mockDataSource.resolveURLResult = .failure(TestError.notFound)
        
        do {
            _ = try await repository.resolveURL(alias: alias)
            XCTFail("Should throw not found error")
        } catch TestError.notFound {
        } catch {
            XCTFail("Should throw not found error, got: \(error)")
        }
        XCTAssertTrue(mockDataSource.resolveURLCalled)
        XCTAssertEqual(mockDataSource.lastResolveURLAlias, alias)
    }
    
    func testGetShortenedURLs_Success() async throws {
        let url1 = URL(string: "https://example1.com")!
        let url2 = URL(string: "https://example2.com")!
        
        let response1 = ShortenResponse(
            alias: "abc1",
            _links: ShortenResponse.Links(
                self_: URL(string: "https://api.example.com/abc1")!,
                short: URL(string: "https://short.ly/abc1")!
            )
        )
        let response2 = ShortenResponse(
            alias: "abc2",
            _links: ShortenResponse.Links(
                self_: URL(string: "https://api.example.com/abc2")!,
                short: URL(string: "https://short.ly/abc2")!
            )
        )
        
        mockDataSource.shortenURLResult = .success(response1)
        _ = try await repository.shortenURL(url1)
        
        mockDataSource.shortenURLResult = .success(response2)
        _ = try await repository.shortenURL(url2)
        
        let result = try await repository.getShortenedURLs()
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.alias, "abc2")
        XCTAssertEqual(result.last?.alias, "abc1")
    }
    
    func testDeleteShortenedURL_Success() async throws {
        let url = URL(string: "https://example.com")!
        let response = ShortenResponse(
            alias: "abc123",
            _links: ShortenResponse.Links(
                self_: URL(string: "https://api.example.com/abc123")!,
                short: URL(string: "https://short.ly/abc123")!
            )
        )
        
        mockDataSource.shortenURLResult = .success(response)
        let entity = try await repository.shortenURL(url)
        
        try await repository.deleteShortenedURL(id: entity.id)
        
        let result = try await repository.getShortenedURLs()
        XCTAssertEqual(result.count, 0)
    }
}
