import XCTest
@testable import app_challenge
@testable import Network

final class URLShortenerRemoteDataSourceTests: XCTestCase {
    
    var dataSource: URLShortenerRemoteDataSource!
    var mockRequestManager: MockRequestManager!
    
    override func setUpWithError() throws {
        mockRequestManager = MockRequestManager()
        dataSource = URLShortenerRemoteDataSource(requestManager: mockRequestManager)
    }
    
    override func tearDownWithError() throws {
        dataSource = nil
        mockRequestManager = nil
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
        mockRequestManager.requestResult = .success(mockResponse)
        
        let result = try await dataSource.shortenURL(url)
        
        XCTAssertEqual(result.alias, mockResponse.alias)
        XCTAssertEqual(result._links.short, mockResponse._links.short)
        XCTAssertTrue(mockRequestManager.requestCalled)
    }
    
    func testShortenURL_NetworkError() async throws {
        let url = URL(string: "https://example.com")!
        mockRequestManager.requestResult = .failure(RequestError.networkError("Connection failed"))
        
        do {
            _ = try await dataSource.shortenURL(url)
            XCTFail("Should throw network error")
        } catch RequestError.networkError {
        } catch {
            XCTFail("Should throw network error, got: \(error)")
        }
        XCTAssertTrue(mockRequestManager.requestCalled)
    }
    
    func testResolveURL_Success() async throws {
        let alias = "abc123"
        let expectedURL = URL(string: "https://example.com")!
        let resolveResponse = ResolveResponse(url: expectedURL)
        mockRequestManager.requestResult = .success(resolveResponse)
        
        let result = try await dataSource.resolveURL(alias: alias)
        
        XCTAssertEqual(result.url, expectedURL)
        XCTAssertTrue(mockRequestManager.requestCalled)
    }
    
    func testResolveURL_NotFound() async throws {
        let alias = "nonexistent"
        mockRequestManager.requestResult = .failure(RequestError.httpError(statusCode: 404, message: "Not found", data: nil))
        
        do {
            _ = try await dataSource.resolveURL(alias: alias)
            XCTFail("Should throw not found error")
        } catch RequestError.httpError(let statusCode, _, _) where statusCode == 404 {
        } catch {
            XCTFail("Should throw not found error, got: \(error)")
        }
        XCTAssertTrue(mockRequestManager.requestCalled)
    }
}
