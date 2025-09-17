import XCTest
@testable import Network

final class EndPointTypeTests: XCTestCase {
    
    func testMockEndpointConformsToProtocol() {
        let endpoint = MockEndpoint()
        XCTAssertTrue(endpoint is EndPointType)
    }
    
    func testMockEndpointDefaultValues() {
        let endpoint = MockEndpoint()
        
        XCTAssertEqual(endpoint.path, "/test")
        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertNil(endpoint.headers)
        XCTAssertEqual(endpoint.queryParameters.count, 0)
        XCTAssertNil(endpoint.body)
        XCTAssertFalse(endpoint.requiresAuth)
    }
    
    func testMockEndpointCustomValues() {
        let headers = ["Authorization": "Bearer token"]
        let queryParams = ["page": 1, "limit": 10]
        let body = Data("test body".utf8)
        
        let endpoint = MockEndpoint(
            path: "/api/custom",
            httpMethod: .post,
            headers: headers,
            queryParameters: queryParams,
            body: body,
            requiresAuth: true
        )
        
        XCTAssertEqual(endpoint.path, "/api/custom")
        XCTAssertEqual(endpoint.httpMethod, .post)
        XCTAssertEqual(endpoint.headers, headers)
        XCTAssertEqual(endpoint.queryParameters.count, 2)
        XCTAssertEqual(endpoint.body, body)
        XCTAssertTrue(endpoint.requiresAuth)
    }
    
    func testMockEndpointWithAllHTTPMethods() {
        let methods: [HTTPMethod] = [.get, .post, .put, .delete, .patch]
        
        for method in methods {
            let endpoint = MockEndpoint(httpMethod: method)
            XCTAssertEqual(endpoint.httpMethod, method)
        }
    }
    
    func testMockEndpointWithComplexQueryParameters() {
        let queryParams: [String: Any] = [
            "search": "hello world",
            "category": "tech",
            "active": true,
            "count": 42,
            "tags": ["swift", "ios"]
        ]
        
        let endpoint = MockEndpoint(queryParameters: queryParams)
        
        XCTAssertEqual(endpoint.queryParameters.count, 5)
        XCTAssertEqual(endpoint.queryParameters["search"] as? String, "hello world")
        XCTAssertEqual(endpoint.queryParameters["category"] as? String, "tech")
        XCTAssertEqual(endpoint.queryParameters["active"] as? Bool, true)
        XCTAssertEqual(endpoint.queryParameters["count"] as? Int, 42)
        XCTAssertEqual(endpoint.queryParameters["tags"] as? [String], ["swift", "ios"])
    }
    
    func testMockEndpointWithHeaders() {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
        ]
        
        let endpoint = MockEndpoint(headers: headers)
        
        XCTAssertEqual(endpoint.headers?.count, 3)
        XCTAssertEqual(endpoint.headers?["Content-Type"], "application/json")
        XCTAssertEqual(endpoint.headers?["Accept"], "application/json")
        XCTAssertEqual(endpoint.headers?["Authorization"], "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")
    }
    
    func testMockEndpointWithBody() {
        let jsonData = """
        {
            "name": "Test User",
            "email": "test@example.com",
            "active": true
        }
        """.data(using: .utf8)!
        
        let endpoint = MockEndpoint(body: jsonData)
        
        XCTAssertEqual(endpoint.body, jsonData)
        XCTAssertNotNil(endpoint.body)
    }
}
