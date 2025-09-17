import XCTest
@testable import Network

final class URLBuilderTests: XCTestCase {
    
    func testBuildURLWithSimplePath() throws {
        let endpoint = MockEndpoint(path: "/api/test")
        let url = try URLBuilder.buildURL(baseURL: "https://example.com", endpoint: endpoint)
        
        XCTAssertEqual(url.absoluteString, "https://example.com/api/test")
    }
    
    func testBuildURLWithQueryParameters() throws {
        let endpoint = MockEndpoint(
            path: "/api/search",
            queryParameters: ["q": "test", "page": 1]
        )
        let url = try URLBuilder.buildURL(baseURL: "https://example.com", endpoint: endpoint)
        
        XCTAssertTrue(url.absoluteString.contains("q=test"))
        XCTAssertTrue(url.absoluteString.contains("page=1"))
        XCTAssertTrue(url.absoluteString.contains("https://example.com/api/search"))
    }
    
    func testBuildURLWithEmptyQueryParameters() throws {
        let endpoint = MockEndpoint(path: "/api/test", queryParameters: [:])
        let url = try URLBuilder.buildURL(baseURL: "https://example.com", endpoint: endpoint)
        
        XCTAssertEqual(url.absoluteString, "https://example.com/api/test")
    }

    
    func testBuildURLWithComplexQueryParameters() throws {
        let endpoint = MockEndpoint(
            path: "/api/search",
            queryParameters: [
                "q": "hello world",
                "category": "tech",
                "limit": 10,
                "active": true
            ]
        )
        let url = try URLBuilder.buildURL(baseURL: "https://example.com", endpoint: endpoint)
        
        XCTAssertTrue(url.absoluteString.contains("q=hello%20world"))
        XCTAssertTrue(url.absoluteString.contains("category=tech"))
        XCTAssertTrue(url.absoluteString.contains("limit=10"))
        XCTAssertTrue(url.absoluteString.contains("active=true"))
    }
    
    func testBuildURLWithExistingQueryParameters() throws {
        let endpoint = MockEndpoint(
            path: "/api/search?existing=param",
            queryParameters: ["new": "value"]
        )
        let url = try URLBuilder.buildURL(baseURL: "https://example.com", endpoint: endpoint)
        
        XCTAssertTrue(url.absoluteString.contains("existing=param"))
        XCTAssertTrue(url.absoluteString.contains("new=value"))
    }
}
