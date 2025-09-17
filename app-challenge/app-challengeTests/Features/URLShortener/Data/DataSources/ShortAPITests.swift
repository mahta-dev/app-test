import XCTest
@testable import app_challenge
@testable import Network

final class ShortAPITests: XCTestCase {
    
    func testCreateEndpoint() {
        let url = URL(string: "https://example.com")!
        let endpoint = ShortAPI.create(url: url)
        
        XCTAssertEqual(endpoint.path, "/api/alias")
        XCTAssertEqual(endpoint.httpMethod, .post)
        XCTAssertEqual(endpoint.queryParameters.count, 0)
        
        XCTAssertNotNil(endpoint.body)
        XCTAssertEqual(endpoint.headers?["Content-Type"], "application/json")
    }
    
    func testResolveEndpoint() {
        let alias = "abc123"
        let endpoint = ShortAPI.resolve(alias: alias)
        
        XCTAssertEqual(endpoint.path, "/api/alias/\(alias)")
        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertEqual(endpoint.queryParameters.count, 0)
        XCTAssertNil(endpoint.body)
        XCTAssertEqual(endpoint.headers?["Accept"], "application/json")
    }
    
    func testHeaders() {
        let url = URL(string: "https://example.com")!
        let createEndpoint = ShortAPI.create(url: url)
        let resolveEndpoint = ShortAPI.resolve(alias: "abc123")
        
        XCTAssertEqual(createEndpoint.headers?["Content-Type"], "application/json")
        XCTAssertEqual(createEndpoint.headers?["Accept"], "application/json")
        XCTAssertEqual(resolveEndpoint.headers?["Accept"], "application/json")
    }
}